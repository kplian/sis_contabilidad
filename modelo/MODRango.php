<?php
/**
*@package pXP
*@file gen-MODRango.php
*@author  (admin)
*@date 22-06-2017 21:30:05
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRango extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRango(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_rango_sel';
		$this->transaccion='CONTA_RAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->capturaCount('debe_mb','numeric');
		$this->capturaCount('haber_mb','numeric');
		$this->capturaCount('debe_mt','numeric');
		$this->capturaCount('haber_mt','numeric');
		
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_rango','int4');
		$this->captura('id_periodo','int4');
		$this->captura('haber_mb','numeric');
		$this->captura('debe_mb','numeric');
		$this->captura('debe_mt','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_tipo_cc','int4');
		$this->captura('haber_mt','numeric');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('periodo','int4');
		$this->captura('gestion','int4');
		$this->captura('fecha_ini','date');
		$this->captura('fecha_fin','date');
		$this->captura('desc_tipo_cc','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRango(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_rango_ime';
		$this->transaccion='CONTA_RAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('haber_mb','haber_mb','numeric');
		$this->setParametro('debe_mb','debe_mb','numeric');
		$this->setParametro('debe_mt','debe_mt','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('haber_mt','haber_mt','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRango(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_rango_ime';
		$this->transaccion='CONTA_RAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rango','id_rango','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('haber_mb','haber_mb','numeric');
		$this->setParametro('debe_mb','debe_mb','numeric');
		$this->setParametro('debe_mt','debe_mt','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('haber_mt','haber_mt','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRango(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_rango_ime';
		$this->transaccion='CONTA_RAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rango','id_rango','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarTipoCcArbRep(){
		    //Definicion de variables para ejecucion del procedimientp
		   $this->procedimiento='conta.ft_rango_sel';
		    $this-> setCount(false);
		    $this->transaccion='CONTA_TCCREP_SEL';
		    $this->tipo_procedimiento='SEL';//tipo de transaccion
		    
		    $id_padre = $this->objParam->getParametro('id_padre');
		    
		    $this->setParametro('node','node','varchar'); 
			$this->setParametro('desde','desde','date');
			$this->setParametro('hasta','hasta','date');
			  
		            
		    //Definicion de la lista del resultado del query
		    $this->captura('id_tipo_cc','int4');
			$this->captura('codigo','varchar');			
			$this->captura('control_techo','varchar');
			$this->captura('mov_pres','varchar');			
			$this->captura('estado_reg','varchar');
			$this->captura('movimiento','varchar');			
			$this->captura('id_ep','int4');
			$this->captura('id_tipo_cc_fk','int4');			
			$this->captura('descripcion','varchar');
			$this->captura('tipo','varchar');			
			$this->captura('control_partida','varchar');
			$this->captura('momento_pres','varchar');			
			$this->captura('fecha_inicio','date');
			$this->captura('fecha_final','date');
			$this->captura('tipo_nodo','varchar');			
			$this->captura('debe_mb','numeric');
			$this->captura('haber_mb','numeric');
			$this->captura('balance_mb','numeric');			
			$this->captura('debe_mt','numeric');
			$this->captura('haber_mt','numeric');
			$this->captura('balance_mt','numeric');
			
			 
		     //Ejecuta la instruccion
		     $this->armarConsulta();
			 $this->ejecutarConsulta();
		    
		    return $this->respuesta;       
    }

    function sincronizarRangos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_balance_tcc_sinc';
		$this->transaccion='CONTA_SINCRAN_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

			


			
}
?>