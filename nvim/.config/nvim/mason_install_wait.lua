local name = ... or "js-debug-adapter"
local registry = require("mason-registry")
local done = false
local ok = false
registry.refresh(function()
  local ok_pkg, pkg = pcall(registry.get_package, name)
  if not ok_pkg then
    print("Package not found: " .. name)
    done = true
    return
  end
  if pkg:is_installed() then
    print("Already installed: " .. name)
    done = true
    ok = true
    return
  end
  print("Installing: " .. name)
  pkg:install():on("closed", function()
    if pkg:is_installed() then
      print("Installed: " .. name)
      ok = true
    else
      print("Failed: " .. name)
    end
    done = true
  end)
end)
-- wait up to 20 minutes
vim.wait(20 * 60 * 1000, function() return done end, 500)
if not ok then
  print("Install did not complete successfully for " .. name)
end
