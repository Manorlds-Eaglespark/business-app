

class Helpers:
   def remove_dupes(self, mylist):
        newlist = [mylist[0]]
        for e in mylist:
            if e not in newlist:
                newlist.append(e)
        return newlist