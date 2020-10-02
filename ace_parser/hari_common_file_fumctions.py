def read_a_file_line_by_line(input_file):
   file1 = open(input_file, 'r') 
   Lines = file1.readlines() 
   return(Lines)
  

def print_stripped_lines(Lines):
   count = 0
   # Strips the newline character 
   list_of_lines = []
   for line in Lines: 
      print(line.strip()) 
#      print("Line{}: {}".format(count, line.strip())) 

def return_list_of_lines(Lines):
   count = 0
   # Strips the newline character 
   list_of_lines = []
   for line in Lines:
      list_of_lines.append(line.strip())
#   print(list_of_lines)
   return(list_of_lines)


#Lines=read_a_file_line_by_line("../output_fat_boy_ripe_banana")
#return_list_of_lines(Lines)
