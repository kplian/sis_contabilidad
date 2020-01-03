<?php
/**
*@package pXP
*@file gen-MODImpuestoForm.php
*@author  (miguel.mamani)
*@date 29-07-2019 21:50:22
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODImpuestoForm extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarImpuestoForm(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_impuesto_form_sel';
		$this->transaccion='CONTA_IMP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_impuesto_form','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('id_impuesto_form_padre','int4');
		$this->captura('id_reporte_anexos','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo','varchar');
        $this->captura('id_gestion','int4');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarImpuestoForm(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_impuesto_form_ime';
		$this->transaccion='CONTA_IMP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_impuesto_form_padre','id_impuesto_form_padre','int4');
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
		$this->setParametro('codigo','codigo','varchar');
        $this->setParametro('id_gestion','id_gestion','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarImpuestoForm(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_impuesto_form_ime';
		$this->transaccion='CONTA_IMP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_impuesto_form','id_impuesto_form','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_impuesto_form_padre','id_impuesto_form_padre','int4');
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('id_gestion','id_gestion','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarImpuestoForm(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_impuesto_form_ime';
		$this->transaccion='CONTA_IMP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_impuesto_form','id_impuesto_form','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>