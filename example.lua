local loggy = require 'loggy'

-- custom formatter with ANSI colors:
local terminalColors = {
  red = "\x1B[31m",
  cyan = "\x1b[36m",
  brightBlack = "\x1b[90m",
  yellow = "\x1b[33m",
  reset = "\x1B[0m",
}
local coloredTerminalFormatter = function(level, msg)
  local color = terminalColors.red
  if level == loggy.WARN then color = terminalColors.yellow end
  if level < loggy.WARN then color = terminalColors.cyan end
  if level < loggy.INFO then color = terminalColors.brightBlack end

  local dateStr = os.date("%Y-%m-%d %H:%M:%S")
  return string.format("%s%s %s: %s%s\n", color, dateStr,
    loggy.levelLabel[level], msg, terminalColors.reset)
end

-- log all messages to terminal, and only warnings/critical messages to a file:
loggy.loggers = {
  {
    minLevel = loggy.VERBOSE,
    send = function(level, msg) io.write(msg) end,
    formatter = coloredTerminalFormatter,
  },
  {
    minLevel = loggy.WARN,
    send = function(level, msg)
      local f = io.open('log.txt', 'a')
      f:write(msg)
      f:close()
    end,
  },
}

loggy.log(loggy.VERBOSE, "a verbose message")
loggy.error("an error happened: %s", "error name")
loggy.info("a message")
loggy.debug("debug info")
loggy.warn("something happened")
loggy.critical("program must close")
loggy.verbose("a verbose message")
