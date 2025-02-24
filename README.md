# 🖩 Assembly Calculator  

A simple calculator built using **x86 Assembly (MASM/TASM)** that can perform **basic arithmetic operations** (addition, subtraction, multiplication, and division) on both positive and negative integers.  

## 📌 Features  
✅ Supports **addition, subtraction, multiplication, and division**  
✅ Handles **positive and negative numbers**  
✅ User-friendly **console-based input/output**  
✅ Implements **ASCII to integer conversion** for user input  
✅ Displays results in a structured format  

## ⚙️ How It Works  
1. The program prompts the user to **enter two numbers**.  
2. The user selects an **operation (+, -, *, /)**.  
3. The calculator **processes the input**, performs the operation, and displays the result.  
4. The program **repeats** until the user chooses to exit.  

## 🛠 Technologies Used  
- **x86 Assembly** (MASM/TASM)  
- **DOS interrupts (INT 21H)** for input/output  

## 🚀 Setup & Usage  
1. Clone this repository:  

   ```sh
   git clone https://github.com/yourusername/assembly-calculator.git
   cd assembly-calculator

2. Assemble and run the program using MASM/TASM:

    ```sh 
    masm calculator.asm
    link calculator.obj
    calculator.exe

