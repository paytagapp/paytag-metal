class MockGPIO:
    BCM = None
    OUT = None
    IN = None
    HIGH = True
    LOW = False

    def setmode(self, mode):
        pass

    def setup(self, channel, mode):
        pass

    def output(self, channel, state):
        pass

    def input(self, channel):
        return False

    def cleanup(self):
        pass

GPIO = MockGPIO()
