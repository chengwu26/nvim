local M = {}

---@alias Env "Windows"|"Linux"|"WSL"|"OSX"|"BSD"|"POSIX"|"Other"

--- Current environment
---@type Env
M.env = os.getenv("WSL_DISTRO_NAME") and "WSL" or jit.os

--- Wether or not is development environment
M.is_dev = ENABLE_DEV or os.getenv("DEV_ENV") ---@diagnostic disable-line

return M
