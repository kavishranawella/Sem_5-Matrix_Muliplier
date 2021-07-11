# GUI for compilation and Verification

import tkinter as tk
from tkinter import ttk

window= tk.Tk()

window.title("Compile Assembly Code and Verify the Resultant Matrix")
window.minsize(800,400)

def input_paramters():
    label.configure(text="Parameters Entered!")
    global noc
    global input_1_rows_A
    global input_2_common_dim
    global input_3_cols_B
    noc = int(noc_input.get("1.0","end"))
    input_1_rows_A = int(row_A_input.get("1.0","end"))
    input_2_common_dim = int(common_input.get("1.0","end"))
    input_3_cols_B = int(col_B_input.get("1.0","end"))
    code_box.delete('1.0', "end")

# in row-major order
def matrixA_input():
    label.configure(text="Entered Matrix A!")
    global A_matrix
    global matrixA_to_DRAM
    matrixA_to_DRAM = ""
    matrixA_code_string = code_box.get("1.0","end")
    A_matrix = []
    temp1 = matrixA_code_string.split("\n")
    temp2 = []
    matrixA_code_string_list = []
    for i in range(len(temp1)):
        if temp1[i] != "":
            temp2.append(temp1[i])
    
    for i in range(len(temp2)):
        matrixA_code_string_list.extend(temp2[i].split(" "))
    
    for i in range(len(matrixA_code_string_list)):
        matrixA_to_DRAM += " " + hex(int(matrixA_code_string_list[i]))[2:]
    matrixA_to_DRAM = matrixA_to_DRAM[1:]

    temp3 = []
    counter = 0
    for i in range(len(matrixA_code_string_list)):
        temp3.append(int(matrixA_code_string_list[i]))
        counter+=1
        if (counter==input_2_common_dim):
            A_matrix.append(temp3)
            counter = 0
            temp3=[]
    
# in column-major order
def matrixB_input():
    label.configure(text="Entered Matrix B!")
    global matrixB_to_DRAM
    global B_matrix
    B_matrix = []
    matrixB_to_DRAM = ""
    matrixB_code_string = code_box.get("1.0","end")
    temp1 = matrixB_code_string.split("\n")
    temp2 = []
    matrixB_code_string_list = []
    matrixB_code_string_list_column = []
    for i in range(len(temp1)):
        if temp1[i] != "":
            temp2.append(temp1[i])
    
    for i in range(len(temp2)):
        matrixB_code_string_list.extend(temp2[i].split(" "))
    
    for i in range(input_3_cols_B):
        column_count = i
        for j in range(input_2_common_dim):
            matrixB_code_string_list_column.append(matrixB_code_string_list[column_count])
            column_count += input_3_cols_B
    
    for i in range(len(matrixB_code_string_list_column)):
        matrixB_to_DRAM += " " + hex(int(matrixB_code_string_list_column[i]))[2:]

    temp3 = []
    counter = 0
    for i in range(len(matrixB_code_string_list)):
        temp3.append(int(matrixB_code_string_list[i]))
        counter+=1
        if (counter==input_3_cols_B):
            B_matrix.append(temp3)
            counter = 0
            temp3=[]

def compile_data():
    label.configure(text="Compiled Data!")
    to_DRAM = hex(noc)[2:] + " 00 " + hex(input_1_rows_A)[2:] +" 00 " + hex(input_2_common_dim)[2:] + " 00 " + hex(input_3_cols_B)[2:] + " 00 " + hex(20)[2:] + " 00 " + hex(20+(input_1_rows_A*input_2_common_dim))[2:] + " 00 " + hex(20+(input_1_rows_A*input_2_common_dim)+(input_3_cols_B*input_2_common_dim))[2:] +" 00 " + "00 00 00 00 00 00\n"+ matrixA_to_DRAM + "\n" +matrixB_to_DRAM[1:]
    f0 = open("dram.mem", "w")
    f0.write(to_DRAM)
    f0.close()
    f2 = open("./simulation/modelsim/dram.mem", "w")
    f2.write(to_DRAM)
    f2.close()

    global c_from_python
    c_from_python = [[0]*input_3_cols_B for i in range(input_1_rows_A)]
    for i in range(input_1_rows_A):
        for j in range(input_3_cols_B):
            for k in range(input_2_common_dim):
                c_from_python[i][j] += int(A_matrix[i][k]) * int(B_matrix[k][j])

    c_from_python = [item for sublist in c_from_python for item in sublist]

def verify():
    label.configure(text="Verification Test Results")
    f1 = open("./simulation/modelsim/DRAM_out.mem", "r")
    C_matrix = []
    C_matrix_temp = f1.read().split()
    f1.close()
    for i in range(0, len(C_matrix_temp), 2):
        if (C_matrix_temp[i] == "xx"):
            break
        C_matrix.append(C_matrix_temp[i+1]+C_matrix_temp[i])
    verification_result=""
    try:   
        for i in range(len(C_matrix)) :  
            if (c_from_python[i] == int(C_matrix[i], 16)):
                verification_result += "Element "+str(i)+": Correct\n"
            else:
                verification_result += "Element "+str(i)+": Inorrect\n"
                

    except IndexError:
        print("Matrix dimesions do not match!")
        verification_result += "Matrix dimesions do not match!"

    code_box.delete('1.0', "end")
    code_box.insert("end", verification_result)

def clear_text():
    code_box.delete('1.0', "end")
    label.configure(text="Cleared!")


label = tk.Label(window, text = "Matrix Multiplier", fg='#f00')
label.grid(column= 0, row= 0)

scroll = tk.Scrollbar(window)
scroll.grid(row= 1, column= 5, rowspan= 3, sticky='ns')
code_box= tk.Text(window, width= 100, height= 20, yscrollcommand=scroll.set)
scroll.configure(command = code_box.yview)

code_box.grid(column= 0, row= 1, columnspan= 5)

noc_count = tk.Label(window, text = "NoC")
noc_count.grid(column= 0, row= 2)
noc_input= tk.Text(window, width= 10, height= 1)
noc_input.grid(column= 1, row= 2)

row_A = tk.Label(window, text = "# of rows in Matrix A")
row_A.grid(column= 0, row= 3)
row_A_input= tk.Text(window, width= 10, height= 1)
row_A_input.grid(column= 1, row= 3)

common = tk.Label(window, text = "Common dimension")
common.grid(column= 0, row= 4)
common_input= tk.Text(window, width= 10, height= 1)
common_input.grid(column= 1, row= 4)

col_B = tk.Label(window, text = "# of columns in Matrix B")
col_B.grid(column= 0, row= 5)
col_B_input= tk.Text(window, width= 10, height= 1)
col_B_input.grid(column= 1, row= 5)

# Input parameters

button0= ttk.Button(window, text= "Enter parameters", command= input_paramters)
button0.grid(column= 2, row= 2, ipady=5, ipadx=10)

# Data

button2= ttk.Button(window, text= "Enter Matrix A(dec)", command= matrixA_input)
button2.grid(column= 3, row= 2, ipady=5, ipadx=39)

button3= ttk.Button(window, text= "Enter Matrix B(dec)", command= matrixB_input)
button3.grid(column= 3, row= 3, ipady=5, ipadx=39)

button4= ttk.Button(window, text= "Compile Matrices", command= compile_data)
button4.grid(column= 3, row= 4, ipady=5, ipadx=43)

# Verify

button5= ttk.Button(window, text= "Verify", command= verify)
button5.grid(column= 4, row= 2, ipady=5, ipadx=10)

# Clear the textbox

button6= ttk.Button(window, text= "Clear", command= clear_text)
button6.grid(column= 4, row= 5, ipady=5, ipadx=10)

# Window loop

window.mainloop()