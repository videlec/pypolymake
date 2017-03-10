from __future__ import absolute_import

import os

from .handlers import (write_handlers, write_mappings,
        write_declarations, write_definitions)

def rebuild():
    print("*** Rebuilding handlers and mappings ***")

    write_handlers(os.path.join("polymake", "auto_handlers.pxi"))
    write_mappings(os.path.join("polymake", "auto_mappings.pxi"))
#    write_declarations(os.path.join("polymake", "auto_types.pxd"))
#    write_definitions(os.path.join("polymake", "auto_types.pyx"))
