from dataclasses import dataclass
from datetime import datetime

@dataclass
class TagData:
    count: int
    last_read: datetime
    id: str
