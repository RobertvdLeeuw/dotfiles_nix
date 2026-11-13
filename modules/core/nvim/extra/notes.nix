{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    notes.obsidian = {
      enable = false;
      setupOpts = { };
    };

    extraPlugins = {
      render-latex-nvim =
        let
          render-latex-src = pkgs.fetchFromGitHub {
            owner = "techwizrd";
            repo = "render-latex.nvim";
            rev = "v0.1.0-rc5";
            hash = "sha256-6MB36Kkrs1l93oKKoWVEkQjCa84DvXxopo3wKVfSuQE=";
          };

          render-latex-worker = pkgs.rustPlatform.buildRustPackage {
            pname = "render-latex-worker";
            version = "unstable";
            src = render-latex-src;
            cargoHash = "sha256-LHGYA5BmA0GLL8ODVqdvO4FzoIxoH5OQIxwCk6oE4EY=";
            cargoBuildFlags = [
              "-p"
              "render-latex-worker"
            ];
            doCheck = false;
          };
        in
        {
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "render-latex-nvim";
            version = "unstable";
            src = render-latex-src;
            doCheck = false;
          };
          setup = /* lua */ ''
            require("render_latex").setup({
            	install = { auto = false },
            	worker = { bin = "${render-latex-worker}/bin/render-latex-worker" },
            })
          '';
        };

      image-nvim = {
        package = pkgs.vimPlugins.image-nvim;
        setup = /* lua */ ''
          require("image").setup({
          	backend = "kitty",
          	processor = "magick_cli",
          })
        '';
      };

      diagram-nvim = {
        package = pkgs.vimPlugins.diagram-nvim;
        after = [ "image-nvim" ];
        setup = /* lua */ ''
          require("diagram").setup({
          	integrations = {
          		require("diagram.integrations.markdown"),
          	},
          	events = {
          		render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
          		clear_buffer = { "BufLeave" },
          	},
          	renderer_options = {
          		mermaid = {
          			-- Allowed choices are base, dark, default, forest, neutral, neo, neo-dark, redux, redux-dark, redux-color, redux-dark-color, null.
          			theme = "redux-dark-color",
          			background = "transparent",
          			-- cli_args = { "--no-sandbox" },
          		},
          	},
          })
        '';
      };
    };

    luaConfigPost = /* lua */ ''
      do
      	local ns = vim.api.nvim_create_namespace("diagram_hide_src")
      	local rendered, last = {}, {} -- [buf] = { [fence_row] = true } / last conceal key
      	local query =
      		vim.treesitter.query.parse("markdown", "(fenced_code_block (info_string) @info (code_fence_content) @code)")

      	local function blocks(buf)
      		local root = vim.treesitter.get_parser(buf, "markdown"):parse()[1]:root()
      		local out, fence = {}, nil
      		for id, node in query:iter_captures(root, buf) do
      			if query.captures[id] == "info" then
      				fence = node:range()
      			else
      				local first, _, e = node:range()
      				out[#out + 1] = { fence = fence, first = first, last = e - 1 }
      			end
      		end
      		return out
      	end

      	local function cursor_row(buf)
      		local win = vim.api.nvim_get_current_buf() == buf and 0 or vim.fn.bufwinid(buf)
      		if win == -1 then
      			return -1
      		end
      		return vim.api.nvim_win_get_cursor(win)[1] - 1
      	end

      	local function refresh(buf)
      		if not vim.api.nvim_buf_is_valid(buf) then
      			return
      		end
      		local rows, cur, todo, key = rendered[buf] or {}, cursor_row(buf), {}, {}
      		if next(rows) then
      			local ok, bl = pcall(blocks, buf)
      			for _, b in ipairs(ok and bl or {}) do
      				-- hide only blocks with a live image, and never the one the cursor is in
      				if rows[b.fence] and b.last >= b.first and not (cur >= b.fence and cur <= b.last + 1) then
      					todo[#todo + 1] = b
      					key[#key + 1] = b.fence .. ":" .. b.last
      				end
      			end
      		end
      		key = table.concat(key, ",")
      		if last[buf] == key then
      			return
      		end
      		last[buf] = key

      		vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      		for _, b in ipairs(todo) do
      			for row = b.first, b.last do
      				vim.api.nvim_buf_set_extmark(buf, ns, row, 0, { conceal_lines = "" })
      			end
      			-- blank padding line(s) after the image, above the closing fence
      			local pad = {}
      			for _ = 1, 1 do
      				pad[#pad + 1] = { { " ", "" } }
      			end -- change the 1 for more
      			pcall(vim.api.nvim_buf_set_extmark, buf, ns, b.last + 1, 0, {
      				virt_lines = pad,
      				virt_lines_above = true,
      			})
      		end -- lines moved, so re-place the images
      		vim.schedule(function()
      			for _, im in ipairs(require("image").get_images({ buffer = buf })) do
      				im:render()
      			end
      		end)
      	end

      	-- 1. mark a fence as "has image" when diagram.nvim creates one
      	local image = require("image")
      	if not image._hide_src then
      		local orig = image.from_file
      		image.from_file = function(path, opts, ...)
      			local img = orig(path, opts, ...)
      			if img and opts and opts.buffer and opts.inline and opts.y then
      				rendered[opts.buffer] = rendered[opts.buffer] or {}
      				rendered[opts.buffer][opts.y] = true
      				vim.schedule(function()
      					refresh(opts.buffer)
      				end)
      			end
      			return img
      		end
      		image._hide_src = true
      	end

      	-- 2. reset at the start of each diagram.nvim render pass
      	-- (diagram.nvim requires with slashes, so patch both module-name spellings)
      	for _, name in ipairs({ "diagram/integrations/markdown", "diagram.integrations.markdown" }) do
      		local ok, m = pcall(require, name)
      		if ok and not m._hide_src then
      			local orig = m.query_buffer_diagrams
      			m.query_buffer_diagrams = function(bufnr, ...)
      				local buf = bufnr or vim.api.nvim_get_current_buf()
      				rendered[buf] = {}
      				refresh(buf)
      				return orig(bufnr, ...)
      			end
      			m._hide_src = true
      		end
      	end

      	-- 3. reveal the source while the cursor is inside the block
      	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      		callback = function(a)
      			if rendered[a.buf] then
      				refresh(a.buf)
      			end
      		end,
      	})
      	vim.api.nvim_create_autocmd("BufWipeout", {
      		callback = function(a)
      			rendered[a.buf], last[a.buf] = nil, nil
      		end,
      	})
      end
    '';

    options = {
      conceallevel = 2;
      concealcursor = "nc";
    };

    extraPackages = with pkgs; [
      imagemagick
      mermaid-cli
    ];
  };
}
