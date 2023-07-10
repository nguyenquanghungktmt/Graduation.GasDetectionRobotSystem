from enum import Enum
 
class Command(Enum):
    """
    A class define command direct enum

    Attributes:
    ----------

    Methods
    -------
    parse(value)
        convert string value to enum
    """

    START = 'start'
    PAUSE = 'pause'
    FINISH = 'finish'
    SPEED_UP = 'speed_up'
    SPEED_DOWN = 'speed_down'
    UNDEFINED = ''

    def parse(value):
        if not value :
            return Command.UNDEFINED
        return Command(value)