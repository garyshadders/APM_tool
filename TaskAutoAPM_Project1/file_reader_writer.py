"""
Author: Gary Shadders
Date: 03/18/2024
Program description: This python script has a read function that takes in the iris text file and goes line by line,
removes white space and splits the elements of the line by comma and then checks each element if it is a float or not,
makes the conversion between string to float, doubling it, then back to a string and adding it a list that gets returned. 

This read function gets called in the write function to get the list of doubled floats then writes it to a new text file. 
The main function takes in the two file paths as strings and passes it into the write function when it is called 
"""


#This function reads in the text file, goes line by line and returns a list of doubled float values and the original Iris String names

def read(iris):
    #with open file as text_file allows us to open and close the file automatically outside the with block, I learned this in GCIS 127
    with open(iris, 'r') as text_file:
        L = []
        for line in text_file:
            #remove leading and trailing white space
            line = line.strip()
            #this is a list of subsrtings from the line with the comma as the seperator 
            elements = line.split(",")
            for element in elements:
                #check if element has a '.' as in a floating point value
                if '.' in element:
                    converted_num = float(element)
                    converted_num = converted_num * 2
                    converted_num = str(converted_num)
                    L.append(converted_num)
                    L.append(",")
                else:
                    L.append(element)

    return L

#This function calls the read method, gets the list of new values and names then writes it to the new text file in the proper format 
def write(iris, new_iris):
    L_list = read(iris)

    with open(new_iris, 'w') as new_file:
        #go through each element in the list, L then add it to a text file
        for element in L_list:
            if 'Iris-' in element:
                new_file.write(element + '\n')
            else:
                new_file.write(element)

def main():
    iris = "C:\\Users\\gshad\\OneDrive\\Documents\\Personal Projects\\iris.txt"
    new_iris = "C:\\Users\\gshad\\OneDrive\\Documents\\Personal Projects\\new_iris.txt"
    write(iris, new_iris)


if __name__ == "__main__":
    main()