<?php
/**
*@package pXP
*@file gen-MODDependenciaAnexosDet.php
*@author  (miguel.mamani)
*@date 09-08-2019 13:47:05
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDependenciaAnexosDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDependenciaAnexosDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_dependencia_anexos_det_sel';
		$this->transaccion='CONTA_DDA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_dependencia_anexos_det','int4');
		$this->captura('ordernar','numeric');
		$this->captura('apertura','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('id_dependencia_anexos','int4');
		$this->captura('formula','text');
		$this->captura('cbte_aitb','varchar');
		$this->captura('visible','varchar');
		$this->captura('id_impuesto_form','int4');
		$this->captura('tipo_periodo','varchar');
		$this->captura('codigo','varchar');
		$this->captura('numero','varchar');
		$this->captura('codigo_formulario','varchar');
		$this->captura('titulo','varchar');
		$this->captura('formulario_impuesto','varchar');
		$this->captura('cierre','varchar');
		$this->captura('partida','varchar');
		$this->captura('desglosar','varchar');
		$this->captura('operacion','varchar');
		$this->captura('cuenta','varchar');
		$this->captura('id_impuesto_form_cod','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDependenciaAnexosDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_dependencia_anexos_det_ime';
		$this->transaccion='CONTA_DDA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('ordernar','ordernar','numeric');
		$this->setParametro('apertura','apertura','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('id_dependencia_anexos','id_dependencia_anexos','int4');
		$this->setParametro('formula','formula','text');
		$this->setParametro('cbte_aitb','cbte_aitb','varchar');
		$this->setParametro('visible','visible','varchar');
		$this->setParametro('id_impuesto_form','id_impuesto_form','int4');
		$this->setParametro('tipo_periodo','tipo_periodo','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('numero','numero','varchar');
		$this->setParametro('codigo_formulario','codigo_formulario','varchar');
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('formulario_impuesto','formulario_impuesto','varchar');
		$this->setParametro('cierre','cierre','varchar');
		$this->setParametro('partida','partida','varchar');
		$this->setParametro('desglosar','desglosar','varchar');
		$this->setParametro('operacion','operacion','varchar');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('id_impuesto_form_cod','id_impuesto_form_cod','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDependenciaAnexosDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_dependencia_anexos_det_ime';
		$this->transaccion='CONTA_DDA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_dependencia_anexos_det','id_dependencia_anexos_det','int4');
		$this->setParametro('ordernar','ordernar','numeric');
		$this->setParametro('apertura','apertura','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('id_dependencia_anexos','id_dependencia_anexos','int4');
		$this->setParametro('formula','formula','text');
		$this->setParametro('cbte_aitb','cbte_aitb','varchar');
		$this->setParametro('visible','visible','varchar');
		$this->setParametro('id_impuesto_form','id_impuesto_form','int4');
		$this->setParametro('tipo_periodo','tipo_periodo','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('numero','numero','varchar');
		$this->setParametro('codigo_formulario','codigo_formulario','varchar');
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('formulario_impuesto','formulario_impuesto','varchar');
		$this->setParametro('cierre','cierre','varchar');
		$this->setParametro('partida','partida','varchar');
		$this->setParametro('desglosar','desglosar','varchar');
		$this->setParametro('operacion','operacion','varchar');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('id_impuesto_form_cod','id_impuesto_form_cod','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDependenciaAnexosDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_dependencia_anexos_det_ime';
		$this->transaccion='CONTA_DDA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_dependencia_anexos_det','id_dependencia_anexos_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>