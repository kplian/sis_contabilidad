<?php
/**
*@package pXP
*@file gen-MODResultadoPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:12:43
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODResultadoPlantilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarResultadoPlantilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_resultado_plantilla_sel';
		$this->transaccion='CONTA_RESPLAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_resultado_plantilla','int4');
		$this->captura('codigo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tipo','varchar');
        $this->captura('cbte_aitb','varchar');
        $this->captura('cbte_apertura','varchar');
        $this->captura('cbte_cierre','varchar');
        $this->captura('periodo_calculo','varchar');
        $this->captura('id_clase_comprobante','integer');
        $this->captura('glosa','varchar');
		$this->captura('desc_clase_comprobante','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarResultadoPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_plantilla_ime';
		$this->transaccion='CONTA_RESPLAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('tipo','tipo','varchar');
        $this->setParametro('cbte_aitb','cbte_aitb','varchar');
        $this->setParametro('cbte_apertura','cbte_apertura','varchar');
        $this->setParametro('cbte_cierre','cbte_cierre','varchar');
        $this->setParametro('periodo_calculo','periodo_calculo','varchar');
        $this->setParametro('id_clase_comprobante','id_clase_comprobante','integer');
        $this->setParametro('glosa','glosa','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarResultadoPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_plantilla_ime';
		$this->transaccion='CONTA_RESPLAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('tipo','tipo','varchar');
        $this->setParametro('cbte_aitb','cbte_aitb','varchar');
        $this->setParametro('cbte_apertura','cbte_apertura','varchar');
        $this->setParametro('cbte_cierre','cbte_cierre','varchar');
        $this->setParametro('periodo_calculo','periodo_calculo','varchar');
        $this->setParametro('id_clase_comprobante','id_clase_comprobante','integer');
        $this->setParametro('glosa','glosa','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarResultadoPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_plantilla_ime';
		$this->transaccion='CONTA_RESPLAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function clonarPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_plantilla_ime';
		$this->transaccion='CONTA_CLONARPLT_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>