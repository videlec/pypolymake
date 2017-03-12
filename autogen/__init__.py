from __future__ import absolute_import

import os

from .handlers import (write_handlers, write_mappings,
        write_declarations, write_definitions,
        write_undefined_classes)

def rebuild():
    print("*** Rebuilding handlers and mappings ***")

    write_handlers(os.path.join("polymake", "auto_handlers.pxi"))
    write_mappings(os.path.join("polymake", "auto_mappings.pxi"))
    write_declarations()
    write_undefined_classes()
