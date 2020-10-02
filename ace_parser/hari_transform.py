'''
Convert List to a String
Ref:
'''
# Python program to convert a list 
# to string,  Using .join() method
   
my_list = ['I', 'want', 'four', 'apples', 'and', 'eighteen', 'bananas'] 
  
def list_to_string(my_list):
   s1=" "
   return(s1.join(my_list))
  
#print(list_to_string(my_list))
'''
Convert String to Words
This method also used regular expressions, but string function of getting all the punctuations is used to ignore all the punctuation marks and get the filtered result string.
'''
import re
#import string
def string_to_words(inp_string):
   res = re.findall(r'\w+', inp_string)
   return(res)

string1 = "She killed him with a knife when he was sleeping."
string2 = "He was killed by her with a knife when he was sleeping."
string3 = "He was killed by her, with a knife, when he was sleeping."
res = string_to_words(string3)
#print(res)
