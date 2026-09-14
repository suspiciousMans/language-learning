# 03 — Modules and Packages: Reference Solutions

## Package layout

```
mypackage/
├── __init__.py
├── math_utils.py
└── string_utils.py
```

## Import patterns (from exercise_imports.py)

```python
import mypackage
from mypackage import math_utils
from mypackage.math_utils import factorial as fact
```

## Running the package

```bash
# From the project root:
python3 projects/03-modules-and-packages/exercise_imports.py

# Or run a module directly:
python3 -m projects.03-modules-and-packages.mypackage.math_utils
```

## requirements.txt

```text
requests>=2.31
pydantic>=2.0
```

Install with `pip install -r requirements.txt` inside a virtual environment.
