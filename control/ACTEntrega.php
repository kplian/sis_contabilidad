<?php
/**
*@package pXP
*@file gen-ACTEntrega.php
*@author  (admin)
*@date 17-11-2016 19:50:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/REntregaXls.php');
class ACTEntrega extends ACTbase{    
			
	function listarEntrega(){
		$this->objParam->defecto('ordenacion','id_entrega');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('id_depto')!=''){
			$this->objParam->addFiltro("ent.id_depto_conta = ".$this->objParam->getParametro('id_depto'));	
		}
         if ($this->objParam->getParametro('pes_estado') == 'EntregaConsulta') {
            $this->objParam->addFiltro("ent.estado  in (''vbconta'')");
        }
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEntrega','listarEntrega');
		} else{
			$this->objFunc=$this->create('MODEntrega');
			
			$this->res=$this->objFunc->listarEntrega($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEntrega(){
		$this->objFunc=$this->create('MODEntrega');	
		if($this->objParam->insertar('id_entrega')){
			$this->res=$this->objFunc->insertarEntrega($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEntrega($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEntrega(){
		$this->objFunc=$this->create('MODEntrega');	
		$this->res=$this->objFunc->eliminarEntrega($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function crearEntrega(){
		$this->objFunc=$this->create('MODEntrega');	
		$this->res=$this->objFunc->crearEntrega($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function cambiarEstado(){
		$this->objFunc=$this->create('MODEntrega');	
		$this->res=$this->objFunc->cambiarEstado($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	
	
	function recuperarEntrega(){    	
		$this->objFunc = $this->create('MODEntrega');
		$cbteHeader = $this->objFunc->recuperarEntrega($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		} 
    }
	
	function reporteEntrega(){
		
			    
				$nombreArchivo = uniqid(md5(session_id()).'Entrega').'.xls'; 
				$dataSource = $this->recuperarEntrega();
				
				//parametros basicos
				$tamano = 'LETTER';
				$orientacion = 'L';
				$titulo = 'Consolidado';
				
				$this->objParam->addParametro('orientacion',$orientacion);
				$this->objParam->addParametro('tamano',$tamano);		
				$this->objParam->addParametro('titulo_archivo',$titulo);        
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				
				
				$reporte = new REntregaXls($this->objParam); 
				$reporte->datosHeader($dataSource->getDatos(), $this->objParam->getParametro('id_entrega'));
				  $reporte->generarReporte(); 
				
		         
				
				
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}
    function siguienteEstado(){
        $this->objFunc=$this->create('MODEntrega');

        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["id_usuario_reg"]);

        $this->res=$this->objFunc->ListarSiguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function retrosederEstado(){
        $this->objFunc=$this->create('MODEntrega');
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
        $this->res=$this->objFunc->ListarAnteriorEstado($this->objParam);

        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}
?>