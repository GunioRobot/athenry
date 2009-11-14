require 'athenry/commands/setup'
require 'athenry/commands/build'
require 'athenry/commands/target'
require 'athenry/commands/freshen'
require 'athenry/commands/clean'
require 'athenry/shell/aliases'
require 'athenry/commands/resume'
require 'athenry/commands/rescue'

include Athenry::State
include Athenry::ResumeTree
include Athenry::Helper

overlays_basharray
