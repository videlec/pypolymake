from __future__ import absolute_import

import os

from .handlers import write_handlers, write_mappings

def rebuild():
    print("*** Rebuilding handlers and mappings ***")

    write_handlers(os.path.join("polymake", "handlers.pxi"))
    write_mappings(os.path.join("polymake", "auto_mappings.pxi"))
