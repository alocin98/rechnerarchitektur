cmake_minimum_required(VERSION 3.10)
project(Serie_4)

set(CMAKE_CXX_STANDARD 11)

add_executable(Serie_4
        "Additional Information/ARM-Assembly-Language.pdf"
        "Additional Information/ARM-Instruction-Set-Full-Reference-Card.pdf"
        "Additional Information/introduction-series-4.pdf"
        "Additional Information/Raspberry-Pi-Einfuehrung.pdf"
        "Additional Information/Uebungsstunde Woche 09.pdf"
        skeleton/knight-rider-cedric.s
        skeleton/knight-rider-gan.s
        skeleton/knight-rider-nicolas.s
        skeleton/knight-rider.s
        skeleton/Makefile
        serie4.pdf)
