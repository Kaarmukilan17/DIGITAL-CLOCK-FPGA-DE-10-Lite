# Digital Clock on DE10-Lite FPGA

This project implements a **real-time digital clock** on a **7-segment display** using the **Intel DE10-Lite FPGA board**. It includes adjustable time, 12/24 hour format toggle, and time zone switching (+2 hour offset). The project was written in Verilog and tested directly on hardware.

---

## 🚀 Features

- **Real-time clock**: Updates every second using a 50 MHz clock divider.
- **Manual time setting mode**: Increment hours and minutes via push buttons.
- **12-hour and 24-hour display modes**: Toggle format via switch.
- **Time zone support**: Toggle between IST (GMT+5:30) and GMT+3:30 via switch.
- **Hardware-tested**: Verified on DE10-Lite using 6-digit 7-segment display.

---

## 🧰 Tools Used

- **Hardware**: DE10-Lite FPGA Development Board  
- **Software**: Intel Quartus Prime Lite Edition  

---

## 🎮 Switch & Button Mapping

| Switch/Button | Label  | Function                                  |
|---------------|--------|-------------------------------------------|
| `SW0`         | Reset  | Resets clock to 00:00:00                  |
| `SW1`         | Mode   | Toggle between run and time-setting mode  |
| `SW2`         | Set Hr | Increments hours (in set mode only)       |
| `SW3`         | Set Min| Increments minutes (in set mode only)     |
| `SW4`         | Format | Toggle between 12hr and 24hr display      |
| `SW5`         | T.Zone | Toggle between GMT+3:30 and IST           |

---

## 📸 Hardware Demonstration

![image](https://github.com/user-attachments/assets/fe29242a-be32-4692-9779-ffe75c0b9938)

Refer to the project report **DIGITAL_CLOCK_FPGA_DE10** - VIDEO LINKS for demo videos showcasing the result after each version update.

---

## 📍 Pin Assignment Instructions

1. Download the pin assignment file: `DE10_Lite_pin_assignments.csv` from the GitHub repo.
2. Open Quartus Prime project where the Verilog file is saved.
3. Ensure FPGA device is selected as: `10M50DAF484C7G`.
4. Import assignments:
   - `Assignments > Import Assignments` > select the file
5. View/edit pins:
   - `Assignments > Assignment Editor` > double-click pin > `Node Finder` > List > Add node
6. **Always compile** after making any changes.

---

## 🔼 Uploading Code to FPGA

1. Connect DE10-Lite using the **JTAG connector**
2. In Quartus Prime:
   - Go to `Tools > Programmer`
   - Select the correct hardware
   - Add generated `.sof` file
   - Check `Program/Configure`
3. Hit **Start** — 100% progress confirms upload is complete

---

## 🗂️ Changelog Summary (v1.0.0 – v1.9.0)

| Version | Changes                                                               |
|---------|------------------------------------------------------------------------|
| v1.0.0  | Basic second counter, no minutes/hours                                 |
| v1.1.0  | Added minutes and hour counting                                        |
| v1.2.0  | Added hour setting mode via switches                                   |
| v1.3.0  | Implemented minute increment feature                                   |
| v1.4.0  | Added 12-hour / 24-hour mode toggle                                    |
| v1.5.0  | Cleaned up decoder logic for 7-segment                                 |
| v1.6.0  | Added time zone switch (+2 hr offset)                                  |
| v1.7.0  | Finalized all feature integrations (mode, format, timezone)            |
| v1.8.0  | Reorganized and optimized Verilog structure                            |
| v1.9.0  | Cleaned comments, finalized hardware mapping, tested on DE10-Lite      |

---

## 🔧 Future Improvements / Known Issues

- 🕒 **Manual time setting needs debouncing**  
  Currently, switches used for time-setting cause continuous increment while held down.  
  ✅ *Fix*: Add **edge detection** or **debounce logic**.

- ⏱ **Limited precision during time setting**  
  No pulse generation or delay logic means rapid switching may cause skipped values.  
  ✅ *Fix*: Use one-pulse-per-press logic.

- 🧮 **No segment multiplexing**  
  Each digit uses a dedicated output, consuming more I/O pins.  
  ✅ *Fix*: Implement **digit multiplexing** to reduce pin usage.

- ⚠️ **Rapid prototyping**  
  This project was built in just one day, so minor optimizations were skipped.
  Core features are hardware-tested, but details like pin explanations, simulations, and bug logs were minimized due to time constraints.

---

## 📄 License

This project is shared under the **MIT License**, meaning:

- ✅ You **can use, modify, or share** the code.
- ✅ You **must credit** the original author.
- ❌ You **cannot remove** the license or claim it as your own.

**Commercial or academic use is permitted with proper attribution.**  
Please refer to the [LICENSE](LICENSE) file for full details.

---

## 👤 Authors & Contributors

- **Kaarmukilan** — Developer, GitHub manager, documentation  
- **Bala Murugan** — Contributor (logic implementation & testing)  
- **Dhakshana Bala** — Contributor (design visuals, project media)

