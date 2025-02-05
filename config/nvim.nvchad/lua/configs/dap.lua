local dap = require("dap")

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { os.getenv("HOME") .. "/tools/js-debug/src/dapDebugServer.js", "${port}"},
  }
}

for _, language in ipairs { "typescript", "javascript" } do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}"
    }
  }
end

dap.adapters.php = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/tools/vscode-php-debug/out/phpDebug.js" }
}

dap.configurations.php = {
    {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug:9000 - main",
        port = 9000,
        serverSourceRoot = '/var/www/',
        localSourceRoot = '/Users/guru/projects/programs/',
    },
    {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug:9001",
        port = 9001,
        serverSourceRoot = '/var/www/',
        localSourceRoot = '/Users/guru/projects/programs/',
    },
    {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug:9003",
        port = 9003,
        serverSourceRoot = '/var/www/',
        localSourceRoot = '/Users/guru/projects/programs/',
    }
}
