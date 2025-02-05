local dap = require("dap")

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
