# SYNCHRONOUS FIFO

## **- Project Title** 
Design and simulation of a synchronous FIFO using registers in Verilog

## **- Description** 
This project was developed using Verilog HDL and simulated in Xilinx ISE Design Suite. The main purpose is to implement and simulate a synchronous FIFO (First-In-First-Out) using register-based memory.

## **- How to use** 
Tools required
* ISE Xilinx Design Suite: https://www.xilinx.com/support/download.html
* Virtual box: https://www.virtualbox.org/
* When installing the ISE tool, create a shared folder between your personal computer and the VirtualBox virtual machine. Download the project into that folder, then access the virtual machine and run the program named "syncfifo.xise" with Project Navigator
  
<p align="center">
  <img width="643" height="459" alt="image" src="https://github.com/user-attachments/assets/3a4d682d-c4c3-488c-9997-fdb97a2596c9" />
</p>

## **- License** 
This project is open for learning and academic reference. Please check the LICENSE file (if available) for usage rights and restrictions.

## **- Detail**
FIFO (First-In-First-Out) is a special type of buffer memory that is widely used in digital transmission systems and as data buffers in storage devices. As its name suggests, the data that is written first will be read out first. In a FIFO, the concept of memory addressing is removed—only read and write control ports remain. When write is enabled, external data is stored into the buffer. When a read signal is asserted, data is read out from the buffer in the same order it was written.
<p align="center">
  <img width="833" height="290" alt="image" src="https://github.com/user-attachments/assets/88c6a14a-78c9-44e5-8c77-35d2da76d985" />
</p>

## How FIFO Works

To design a FIFO, we can imagine memory elements arranged in a circular buffer with two pointers: a **write pointer** and a **read pointer**.

- Initially, both the write and read pointers are at position `0` at the beginning of the circle.  
- Each time data is written to the buffer, the **write pointer** is incremented.  
- Similarly, each time data is read from the buffer, the **read pointer** is incremented.  
- This process continues around the circle, ensuring that the output data appears in the same order as it was originally input.

### 🟦 FIFO Empty
When the FIFO is reading data and the **read pointer** increases until it catches up with the **write pointer** — meaning both pointers have the same value — we refer to this state as **FIFO empty**. At this point, the buffer contains no more data to read.

### 🟥 FIFO Full
Conversely, when writing data causes the **write pointer** to catch up with the **read pointer** — again resulting in both pointers having the same value — we refer to this state as **FIFO full**. This indicates that the buffer has no space left to store additional data. In this case, you may need to revisit your design to handle overflow properly.

<p align="center">
  <img width="495" height="600" alt="image" src="https://github.com/user-attachments/assets/fc213350-990f-4344-84db-9544d50c7e3b" />
</p>

##  FIFO Architecture Diagram  
###  General block diagram of the register-based FIFO design  

<p align="center">
  <img width="624" height="416" alt="image" src="https://github.com/user-attachments/assets/7e6045ab-7945-4720-a9c2-f7cbb93e4f11" />

</p>

The FIFO design includes the following main components:

- **Register Array (16x8)**: Temporary memory used to store incoming data.  
- **Write Pointer (`wr_pnt`)** and **Read Pointer (`rd_pnt`)**: Indicate the positions to write to and read from the register array.  
- **Control Logic**: Determines whether the FIFO can perform read or write operations based on the current state of the pointers.  
- **Status Signals**:  
  - `fifofull`: Indicates the FIFO is full.  
  - `notempty`: Indicates the FIFO is not empty.  
  - `fifolen[4:0]`: Current number of stored data elements.
---
_The block diagram is for reference only. Some details in the design have been edited in the code, which may differ from the diagram._

## I/O Ports Description

###  Input Ports

| Signal         | Description |
|----------------|-------------|
| `clk`           | Clock signal driving the entire FIFO register block. |
| `datain[7:0]`   | 8-bit data input to the FIFO. Data is written into the FIFO through this port. |
| `writesig`      | Write Enable. When asserted (`logic 1`), the data on `fifodin` is written into the FIFO. |
| `readsig`       | Read Enable. When asserted (`logic 1`), data is read from the FIFO and appears on `fifoout`. |
| `rst`           | Asynchronous reset. When asserted, all internal registers and pointers are reset to their initial states. |

###  Output Ports

| Signal         | Description |
|----------------|-------------|
| `dataout[7:0]` | 8-bit data output of the FIFO. Data appears here when `fiford` is enabled. |
| `full`     | FIFO Full indicator. When asserted (`logic 1`), the FIFO is full and new incoming data will be lost if written. |
| `empty`     | FIFO Not Empty indicator. When high, the FIFO contains at least one data word ready to be read. |
| `length[4:0]` | Indicates the number of data elements currently stored in the FIFO. Useful for monitoring buffer status. |

## Simulation Result

The waveform below demonstrates the functional behavior of the FIFO register under test:

<img width="1565" height="261" alt="image" src="https://github.com/user-attachments/assets/5b375101-c244-45cd-8eb0-f68631d25e48" />


###  Observations:
- At the beginning (`rst = 1`), the system resets all pointers and outputs.
- Data is written sequentially when `writesig` is asserted. The values `001`, `010`, `011` and `100` are pushed into the FIFO, as seen on the `datain` signal.
- The `length` signal increases accordingly, showing the number of elements stored in FIFO.
- When `readsig` is asserted after writing, data is read out in the same order via `dataout`, confirming FIFO behavior (First-In-First-Out).
- The `empty` and `full` signals correctly reflect the FIFO status during the operation.

 This simulation confirms that the FIFO works correctly for sequential write and read operations.



