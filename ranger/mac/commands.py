# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import *

# A simple command for demonstration purposes follows.
#------------------------------------------------------------------------------

# You can import any python module as needed.
import os

class open(Command):
    """:open [path]

    Open [path] with `open` command.
    """

    def execute(self):
        if self.arg(1):
            target = self.arg(1)
        else:
            target = self.fm.thisfile.path
        self.fm.run(['open', target])
        self.fm.notify("Opened path with 'open' command:" + target)

    def tab(self):
        return self._tab_directory_content()

