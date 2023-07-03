from enum import Enum
 
class Command(Enum):
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