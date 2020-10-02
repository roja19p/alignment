import config
#for x (list or dict etc.) use: identifier in x
# for strings use: find(sub[, start[, end]])
def safe_index(lst_or_strng,pattern):
   my_cnt = lst_or_strng.count(pattern)
   if my_cnt != 0:
      return(lst_or_strng.index(pattern))
   else:
      return("UNKNOWN_VALUE")

'''
l1 = ["rAma","mohana"]
print(safe_index(l1,"mohana"))

s1 = "rAma mohana"
print(safe_index(s1,"mohan"))
'''
'''
ARG0_val = ['x3', 'e8', 'x9', 'x9', 'x3', 'e2', 'e16', 'x17', 'e22', 'x23', 'x23', 'x17', 'e28', 'x29', 'x34', 'x34', 'x40', 'x40', 'i44', 'x29', 'x46', 'e51', 'x52', 'x52', 'x46', 'e58', 'x59', 'x59', 'x66', 'x66', 'i70', 'e71', 'e72', 'x74', 'e79', 'x80', 'e85', 'x86', 'x86', 'e92', 'x80', 'x74']

LBL_val = ['h4', 'h7', 'h10', 'h13', 'h7', 'h1', 'h15', 'h18', 'h21', 'h24', 'h27', 'h21', 'h21', 'h30', 'h33', 'h37', 'h39', 'h41', 'h37', 'h45', 'h47', 'h50', 'h53', 'h56', 'h50', 'h50', 'h60', 'h63', 'h65', 'h67', 'h63', 'h15', 'h15', 'h75', 'h78', 'h81', 'h84', 'h87', 'h90', 'h91', 'h84', 'h78']

lst_modulo_equalities = ['h0', 'h1', 'h5', 'h7', 'h11', 'h13', 'h14', 'h15', 'h19', 'h21', 'h25', 'h27', 'h31', 'h45', 'h35', 'h37', 'h42', 'h39', 'h48', 'h50', 'h54', 'h56', 'h61', 'h63', 'h68', 'h65', 'h76', 'h78', 'h82', 'h84', 'h88', 'h90']

word = ['Egg heads', 'Egg heads', 'Egg', 'Egg', 'heads', 'like', 'eat', 'apple cakes in York street but apple pies in York avenue', 'apple cakes', 'apple', 'apple', 'cakes', 'in', 'York street but apple pies in York avenue', 'York street', 'York', 'street', 'street', 'street', 'but', 'apple pies in York avenue', 'apple pies', 'apple', 'apple', 'pies', 'in', 'York avenue', 'York', 'avenue', 'avenue', 'avenue', 'while', 'designing', 'a', 'chess playing program.', 'chess playing', 'chess playing', 'chess', 'chess', 'playing', 'playing', 'program.']
'''

def id_symbol_to_wrds_indx_x(id_symbol,word,ARG0_val):
   if id_symbol[0] != 'h':
      my_wrd_indx=safe_index(ARG0_val,id_symbol)  
      if my_wrd_indx != "UNKNOWN_VALUE":
        my_wrd = word[my_wrd_indx]
        return(id_symbol+"~"+my_wrd)
      else:
        return(id_symbol+"~"+"???")

def id_symbol_to_wrds_indx_h(id_symbol,word,LBL_val,lst_modulo_equalities):
   if id_symbol[0] == 'h':
      my_wrd_indx = safe_index(LBL_val,id_symbol)
      if my_wrd_indx != "UNKNOWN_VALUE":
         my_wrd = word[my_wrd_indx]
         return(id_symbol+"~"+my_wrd)
      else:
         h_index_number = safe_index(lst_modulo_equalities,id_symbol)
         if h_index_number != "UNKNOWN_VALUE":
            if h_index_number %2 == 0:
               new_h_index_number = h_index_number + 1
            else:
               new_h_index_number = h_index_number - 1 
         new_id_symbol = lst_modulo_equalities[new_h_index_number]
         my_word_indx = safe_index(LBL_val,new_id_symbol) 
         if my_word_indx != "UNKNOWN_VALUE":
            my_wrd = word[my_word_indx]
            return(id_symbol+"="+new_id_symbol+"~"+my_wrd)
         else:
             return(id_symbol+"~"+"???")

def id_symbol_to_wrds_indx(id_symbol,word,ARG0_val,LBL_val,lst_modulo_equalities):
   if id_symbol[0] != 'h':
      return(id_symbol_to_wrds_indx_x(id_symbol,word,ARG0_val))
   else:
      return(id_symbol_to_wrds_indx_h(id_symbol,word,LBL_val,lst_modulo_equalities))

def id_symbol_to_wrds(id_symbol):
   if id_symbol[0] != 'h':
      return(id_symbol_to_wrds_indx_x(id_symbol,word,ARG0_val))
   else:
      return(id_symbol_to_wrds_indx_h(id_symbol,word,LBL_val,lst_modulo_equalities))

'''
def idsymbol_wrds(id_symbol):
   if id_symbol[0] != 'h':
      return(id_symbol_to_wrds_indx_x(id_symbol,word,ARG0_val))
   else:
      return(id_symbol_to_wrds_indx_h(id_symbol,word,LBL_val,lst_modulo_equalities))

'''
#print(id_symbol_to_wrds_indx_x('x46'))
#print(id_symbol_to_wrds_indx_h('h14'))
#print(id_symbol_to_wrds_indx_h('h15'))

