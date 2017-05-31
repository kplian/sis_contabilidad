<?php
/**
*@package pXP
*@file gen-MODBancarizacionPeriodo.php
*@author  (favio.figueroa)
*@date 24-05-2017 16:07:40
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODBancarizacionPeriodo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarBancarizacionPeriodo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_bancarizacion_periodo_sel';
		$this->transaccion='CONTA_BANCAPER_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion


        //Definicion de la lista del resultado del query
        $this->captura('id_bancarizacion_periodo','int4');
        $this->captura('estado','varchar');
        $this->captura('id_periodo','int4');



        $this->captura('estado_reg','varchar');
        $this->captura('usuario_ai','varchar');
                $this->captura('fecha_reg','timestamp');

        $this->captura('id_usuario_reg','int4');

        $this->captura('id_usuario_ai','int4');

        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('periodo','varchar');



        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarBancarizacionPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_bancarizacion_periodo_ime';
		$this->transaccion='CONTA_BANCAPER_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarBancarizacionPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_bancarizacion_periodo_ime';
		$this->transaccion='CONTA_BANCAPER_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_bancarizacion_periodo','id_bancarizacion_periodo','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarBancarizacionPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_bancarizacion_periodo_ime';
		$this->transaccion='CONTA_BANCAPER_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_bancarizacion_periodo','id_bancarizacion_periodo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>