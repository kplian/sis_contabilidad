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
        $this->captura('id_clase_comprobante','integer'); // .....
        $this->captura('glosa','varchar');
		$this->captura('desc_clase_comprobante','varchar');
		
		
		$this->captura('id_tipo_relacion_comprobante','int4');
		$this->captura('relacion_unica','varchar');
		$this->captura('desc_tipo_relacion_comprobante','varchar');
		
		
		
		
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
		$this->setParametro('id_tipo_relacion_comprobante','id_tipo_relacion_comprobante','int4');
		$this->setParametro('relacion_unica','relacion_unica','varchar');
		
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
		$this->setParametro('id_tipo_relacion_comprobante','id_tipo_relacion_comprobante','int4');
		$this->setParametro('relacion_unica','relacion_unica','varchar');
		

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
	
	function exportarDatos() {
		
		$this->procedimiento='conta.ft_resultado_plantilla_sel';
			$this->transaccion='CONTA_EXPRESPLT_SEL';
			$this->tipo_procedimiento='SEL';
			$this->setCount(false);
			
			$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','integer');
			
			//Definicion de la lista del resultado del query
			$this->captura('tipo_reg','varchar');
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
			$this->captura('codigo_clase_comprobante','varchar');
			$this->captura('id_tipo_relacion_comprobante','int4');
		    $this->captura('relacion_unica','varchar');
		    $this->captura('codigo_tipo_relacion_comprobante','varchar');
		
		$this->armarConsulta();	
		
        $this->ejecutarConsulta(); 
		 		
		////////////////////////////
		
		
		if($this->respuesta->getTipo() == 'ERROR'){
			return $this->respuesta;
		}
		else {
		    $this->procedimiento = 'conta.ft_resultado_plantilla_sel';
			$this->transaccion = 'CONTA_EXPREPD_SEL';
			$this->tipo_procedimiento = 'SEL';
			$this->setCount(false);
			$this->resetCaptura();
			$this->addConsulta();		
			
			//Definicion de la lista del resultado del query
			$this->captura('tipo_reg','varchar');
			$this->captura('id_resultado_det_plantilla','int4');
			$this->captura('orden','numeric');
			$this->captura('font_size','varchar');
			$this->captura('formula','varchar');
			$this->captura('subrayar','varchar');
			$this->captura('codigo','varchar');
			$this->captura('montopos','int4');
			$this->captura('nombre_variable','varchar');
			$this->captura('posicion','varchar');
			$this->captura('estado_reg','varchar');
			$this->captura('nivel_detalle','int4');
			$this->captura('origen','varchar');
			$this->captura('signo','varchar');
			$this->captura('codigo_cuenta','varchar');
			$this->captura('id_usuario_ai','int4');
			$this->captura('usuario_ai','varchar');
			$this->captura('fecha_reg','timestamp');
			$this->captura('id_usuario_reg','int4');
			$this->captura('id_usuario_mod','int4');
			$this->captura('fecha_mod','timestamp');
			$this->captura('usr_reg','varchar');
			$this->captura('usr_mod','varchar');
			$this->captura('id_resultado_plantilla','int4');			
			$this->captura('visible','varchar');
			$this->captura('incluir_apertura','varchar');
			$this->captura('incluir_cierre','varchar');
			$this->captura('desc_cuenta','varchar');			
			$this->captura('negrita','varchar');
			$this->captura('cursiva','varchar');
			$this->captura('espacio_previo','int4');
			$this->captura('incluir_aitb','varchar');
			$this->captura('tipo_saldo','varchar');
			$this->captura('signo_balance','varchar');			
			$this->captura('relacion_contable','varchar');
			$this->captura('codigo_partida','varchar');			
			$this->captura('id_auxiliar','int4');
			$this->captura('destino','varchar');
			$this->captura('orden_cbte','numeric');
			$this->captura('codigo_auxiliar','varchar');
			$this->captura('desc_partida','varchar');
			$this->captura('codigo_resultado_plantilla','varchar');
			
			
			
			
		
			
			
			$this->armarConsulta();
			$consulta=$this->getConsulta();			
	  
			$this->ejecutarConsulta($this->respuesta);
			
			if($this->respuesta->getTipo() == 'ERROR'){
				return $this->respuesta;
			}
			else {
			    $this->procedimiento = 'conta.ft_resultado_plantilla_sel';
				$this->transaccion = 'CONTA_EXRPDEP_SEL';
				$this->tipo_procedimiento = 'SEL';
				$this->setCount(false);
				$this->resetCaptura();
				$this->addConsulta();		
				
				
				//Definicion de la lista del resultado del query
				$this->captura('tipo_reg','varchar');
				$this->captura('id_resultado_dep','int4');
				$this->captura('id_resultado_plantilla','int4');
				$this->captura('obs','varchar');
				$this->captura('prioridad','numeric');
				$this->captura('estado_reg','varchar');
				$this->captura('id_usuario_ai','int4');
				$this->captura('fecha_reg','timestamp');
				$this->captura('usuario_ai','varchar');
				$this->captura('id_usuario_reg','int4');
				$this->captura('fecha_mod','timestamp');
				$this->captura('id_usuario_mod','int4');
				$this->captura('usr_reg','varchar');
				$this->captura('usr_mod','varchar');
				$this->captura('codigo_resultado_plantilla','varchar');
				$this->captura('nombre_resultado_plantilla','varchar');
				$this->captura('id_resultado_plantilla_hijo','int4');
				$this->captura('codigo_resultado_plantilla_padre','varchar');
				
				
			    $this->armarConsulta();
				$consulta=$this->getConsulta();			
		  
				$this->ejecutarConsulta($this->respuesta);
			}
			
			
		}

		
       return $this->respuesta;		
	
	}	
			
}
?>