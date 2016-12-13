<font size="8">
<table width="100%" cellpadding="5px"  rules="cols" border="1">
<tbody>	
		<tr>
			<td width="70%"><b>Beneficiario:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['beneficiario']; ?></td>
			<td width="30%"><b>Nro Trámite:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['nro_tramite']; ?></td>
		</tr>
		
		<tr>
			<td><b>Glosa:</b>&nbsp;&nbsp;&nbsp;&nbsp; <?php  echo trim($this->cabecera[0]['glosa1']).'<BR/>'.trim($this->cabecera[0]['glosa2']); ?></td>
			 <?php 
			  if ($this->cabecera[0]['id_moneda'] != $this->cabecera[0]['id_moneda_base']){
			 ?>
		      <td><b>T/C:</b> &nbsp;&nbsp;&nbsp;&nbsp;<?php  echo $this->cabecera[0]['tipo_cambio']; ?></td>
		    <?php } ?>
		</tr>
</tbody>
</table></font>