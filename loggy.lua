local loggy = {
  _VERSION = "loggy.lua v1.0.0",
  _DESCRIPTION = "A simple logging library for Lua programs",
  _URL = "https://github.com/superzazu/loggy.lua",
  _LICENSE = [[zlib License

(C) 2020 Nicolas ALLEMAND

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.]],
}

loggy.VERBOSE = 1
loggy.DEBUG = 2
loggy.INFO = 3
loggy.WARN = 4
loggy.ERROR = 5
loggy.CRITICAL = 6

loggy.levelLabel = {"VERBOSE", "DEBUG", "INFO", "WARN", "ERROR", "CRITICAL"}

loggy.defaultFormatter = function(level, msg)
  return string.format("%s %s: %s\n", os.date("%Y-%m-%d %H:%M:%S"),
    loggy.levelLabel[level], msg)
end

-- the default logger sends all messages to the terminal
loggy.loggers = { { send = function(level, msg) io.write(msg) end } }

loggy.log = function(level, msg, ...)
  level = level or loggy.INFO
  msg = string.format(msg, ...)

  for i = 1, #loggy.loggers do
    local logger = loggy.loggers[i]
    local minLevel = logger.minLevel or loggy.VERBOSE

    if level >= minLevel then
      local formatter = logger.formatter or loggy.defaultFormatter
      local formattedMsg = formatter(level, msg)

      logger.send(level, formattedMsg)
    end
  end
end

loggy.verbose = function(msg, ...) loggy.log(loggy.VERBOSE, msg, ...) end
loggy.debug = function(msg, ...) loggy.log(loggy.DEBUG, msg, ...) end
loggy.info = function(msg, ...) loggy.log(loggy.INFO, msg, ...) end
loggy.warn = function(msg, ...) loggy.log(loggy.WARN, msg, ...) end
loggy.error = function(msg, ...) loggy.log(loggy.ERROR, msg, ...) end
loggy.critical = function(msg, ...) loggy.log(loggy.CRITICAL, msg, ...) end

return loggy
