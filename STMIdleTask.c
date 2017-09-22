* @retval None
   */
 extern void SER_Init(void); 
 extern "C" void _sys_exit(int code);
 int main(void)
 {
   __IO uint32_t i = 0;
   int ac_override = 2;
   const char * av_override[] = { "exe", "-v" }; //turn on verbose mode
   GPIO_InitTypeDef GPIO_InitStructure;
   
   /*!< At this stage the microcontroller clock setting is already configured, 
   this is done through SystemInit() function which is called from startup
   file (startup_stm32fxxx_xx.s) before to branch to application main.
   To reconfigure the default setting of SystemInit() function, refer to
   system_stm32fxxx.c file
   */  
   SER_Init();
   
   RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);
   RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC, ENABLE);
   RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOF, ENABLE);
   RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOI, ENABLE);
   GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7;
   GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
   GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
   GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
   GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_DOWN;
   GPIO_Init(GPIOI, &GPIO_InitStructure);
   GPIOI->BSRRL = GPIO_Pin_7;		//* set GPIO PI7
   GPIOI->BSRRL = GPIO_Pin_6;		//* set GPIO PI6
   GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13 | GPIO_Pin_4 | GPIO_Pin_5; 
   GPIO_Init(GPIOC, &GPIO_InitStructure);
   GPIOC->BSRRL = GPIO_Pin_13 | GPIO_Pin_4 | GPIO_Pin_5;		//* set GPIO PC13, PC4 and PC5
   GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10; 
   GPIO_Init(GPIOF, &GPIO_InitStructure);
   GPIO_InitStructure.GPIO_Pin = GPIO_Pin_12; 
   GPIO_Init(GPIOB, &GPIO_InitStructure);
   GPIOB->BSRRL = GPIO_Pin_12;		//* set GPIO PB12
   printf("Start of unit testing of UsbWrapper class\n");
   
   RUN_ALL_TESTS(ac_override, av_override);
   
   printf("\nEnd of Unit testing of UsbWrapper class\n");  
   _sys_exit (0);
 } 
 #ifdef USE_FULL_ASSERT
 /**
 * @brief  assert_failed
 	
