/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000002484851782_3424634258_init();
    work_m_00000000003883018569_2091391583_init();
    work_m_00000000003842363750_3996337969_init();
    work_m_00000000000053519642_1993937810_init();
    work_m_00000000003842199712_1129440603_init();
    work_m_00000000000917755101_2543836757_init();
    work_m_00000000001147040202_3258266500_init();
    work_m_00000000001698928365_3838344542_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001698928365_3838344542");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
