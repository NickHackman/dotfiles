# frozen_string_literal: true

# Config hash constants
NAME = 'name'
DESTINATION = 'destination'
INSTALL_CHILDREN = 'install_children'
EXCLUDE = 'exclude'
DEPENDENCIES = 'dependencies'
DOCTOR_COMMAND = 'doctor_command'
PROMPT_INSTRUCTIONS = 'prompt_instructions'
DOTS = 'dots'

# Path constants
DOTS_YAML_PATH = 'dots.yml'
DOTS_DIR = Pathname.new(File.expand_path(__dir__)).parent
DEFAULT_PATH = DOTS_DIR + DOTS_YAML_PATH
DOTSFILES_DIR = DOTS_DIR.parent

PAGINATION = 20
