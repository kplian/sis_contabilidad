<?php
/**
*@package pXP
*@file gen-MODImpuestoFormPeriodo.php
*@author  (miguel.mamani)
*@date 29-07-2019 21:50:27
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODImpuestoFormPeriodo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarImpuestoFormPeriodo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_impuesto_form_periodo_sel';
		$this->transaccion='CONTA_IFP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_impuesto_form_periodo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_impuesto_form','int4');
		$this->captura('id_periodo','int4');
		$this->captura('importe','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('periodo','int4');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarImpuestoFormPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_impuesto_form_periodo_ime';
		$this->transaccion='CONTA_IFP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_impuesto_form','id_impuesto_form','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('importe','importe','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarImpuestoFormPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_impuesto_form_periodo_ime';
		$this->transaccion='CONTA_IFP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_impuesto_form_periodo','id_impuesto_form_periodo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_impuesto_form','id_impuesto_form','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('importe','importe','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarImpuestoFormPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_impuesto_form_periodo_ime';
		$this->transaccion='CONTA_IFP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_impuesto_form_periodo','id_impuesto_form_periodo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>