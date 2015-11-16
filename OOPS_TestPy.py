class Test():
    name =""
    
    def __init__(self, name):
        if name != "":
            self.name = name
        else:
            name = "Test"  

    @staticmethod
    def TestX():
        print "In TestX:" + "Hi Vikram"
        
    @classmethod
    def TestY(self, name):
        print "In TestY:" + "Hi " + name       
    
if __name__ == "__main__":
    c1=Test("")
    c1.TestX()
    c1.TestY("Vikram")
