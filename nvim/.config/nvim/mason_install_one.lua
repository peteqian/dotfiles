local name = ... or "js-debug-adapter"
local registry = require("mason-registry")
registry.refresh(function()
  local ok, pkg = pcall(registry.get_package, name)
  if not ok then
    print("Package not found: " .. name)
    return
  end
  if pkg:is_installed() then
    print("Already installed: " .. name)
  else
    print("Installing: " .. name)
    pkg:install():on("closed", function()
      if pkg:is_installed() then
        print("Installed: " .. name)
      else
        print("Failed: " .. name)
      end
    end)
  end
end)
vim.wait(120000, function() return true end)
