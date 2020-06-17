# UI_calculator_STATA
Anahid Bauer


STATA-14 and older version of the Calculator for unemployment insurance benefits.  Based on the program designed by Peter Ganong, Pascal Noel, Peter Robertson and Joseph Vavra  

This code enables you to calculate the level of weekly unemployment insurance (UI) benefits for every state based on an individual's quarterly earnings history. They use the python calculator in Ganong, Noel and Vavra (2020).  

For more details see: https://github.com/ganong-noel/ui_calculator

Instructions:

Modify directories in ui_calculator_master_stata.do file to your own directories to run example as it is.

If you want to run the calculator for other files, save them inside ui_calculator-master folder and modify the name of the file in ui_calculator_master_stata.do

Calculator Details

The calculator computes the benefits of a worker without dependendents as of January 2020. It also can be used to simulate alternative policies, such as Federal Pandemic Unemployment Compensation.

Many states have complex UI benefit rules. As in the python version, I follow the rules described in "Significant Provisions of State Unemployment Laws". If a state has multiple ways of satisfying eligibility or multiple ways of calculating benefits, I include only the first listed way. This document, and therefore the calculator, do not capture every aspect of a state's UI rules. A dictionary of the features used by the calculator can be found in the data_dict.md in https://github.com/ganong-noel/ui_calculator

Acknowledgements

If you find a problem, please open a github issue or even better propose a fix using a pull request.


License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
