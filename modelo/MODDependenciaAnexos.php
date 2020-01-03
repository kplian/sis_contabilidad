<?php
/**
*@package pXP
*@file gen-MODDependenciaAnexos.php
*@author  (miguel.mamani)
*@date 08-08-2019 20:35:20
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDependenciaAnexos extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDependenciaAnexos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_dependencia_anexos_sel';
		$this->transaccion='CONTA_DAS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_dependencia_anexos','int4');
		$this->captura('id_reporte_anexos','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('prioridad','int4');
		$this->captura('obs','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('id_plantilla','int4');
        $this->captura('des_titulo','varchar');
        $this->captura('des_codigo','varchar');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDependenciaAnexos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_dependencia_anexos_ime';
		$this->transaccion='CONTA_DAS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('prioridad','prioridad','int4');
		$this->setParametro('obs','obs','varchar');
        $this->setParametro('id_plantilla','id_plantilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDependenciaAnexos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_dependencia_anexos_ime';
		$this->transaccion='CONTA_DAS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_dependencia_anexos','id_dependencia_anexos','int4');
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('prioridad','prioridad','int4');
		$this->setParametro('obs','obs','varchar');
        $this->setParametro('id_plantilla','id_plantilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDependenciaAnexos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_dependencia_anexos_ime';
		$this->transaccion='CONTA_DAS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_dependencia_anexos','id_dependencia_anexos','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>