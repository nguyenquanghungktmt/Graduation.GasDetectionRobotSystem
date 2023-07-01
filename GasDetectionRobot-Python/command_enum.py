from enum import Enum
 
class Command(Enum):
    START = 'start'
    PAUSE = 'pause'
    FINISH = 'finish'
    SPEED_UP = 'speed_up'
    SPEED_DOWN = 'speed_down'
    UNDEFINED = ''

    def parse(value):
        match value:
            case 'start':
                return Command.START
            case 'pause':
                return Command.PAUSE
            case 'finish':
                return Command.FINISH
            case 'speed_up':
                return Command.SPEED_UP
            case 'speed_down':
                return Command.SPEED_DOWN
            case _:
                return Command.UNDEFINED