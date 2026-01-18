/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, OFBConsulting CHILE, Redhuan D. Oon (www.red1.org) and other contributors 
 * THIS ASSET MAINTENANCE module is contribution of Ramiro Vergara, OFB Consulting, CHILE.
*/
package org.maintenance.component;
//red1 - refactored model for both VMP and WMP GenerateOT classes
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Level;

import org.compiere.model.MDocType;
import org.compiere.model.Query;
import org.compiere.util.CLogger;
import org.compiere.util.DB;
import org.compiere.util.Env;
import org.maintenance.model.X_MP_Maintain;
import org.maintenance.model.X_MP_OT;
import org.maintenance.model.X_MP_OT_Resource;
import org.maintenance.model.X_MP_OT_Task;

public class MPGenerateOT {
	
	private String m_trx;
	private static CLogger log = CLogger.getCLogger(MPGenerateOT.class);

	public boolean createOT(int MP_ID, Timestamp Datetrx,String description,int Asset_ID, String trxName ){
		m_trx = trxName;
		//create header OT
		MMPOT newOT=new MMPOT(Env.getCtx(), 0,trxName);
		newOT.setDateTrx(Datetrx);
		newOT.setDescription(description);
		newOT.setA_Asset_ID(Asset_ID);
		newOT.setMP_Maintain_ID(MP_ID);
		newOT.setDocStatus("DR");
		newOT.setDocAction("CO");
		newOT.setC_DocType_ID(MDocType.getOfDocBaseType(Env.getCtx(), "MOF")[0].getC_DocType_ID());
		if(!newOT.save())//creada nueva OT
			return false;
		
		if(!createOTTaskDetail(MP_ID,newOT,trxName))
			return false;
		List<MMPMaintain> list = new Query(Env.getCtx(),MMPMaintain.Table_Name,MMPMaintain.COLUMNNAME_IsChild+"=? AND "
				+MMPMaintain.COLUMNNAME_MP_MaintainParent_ID+"=?",trxName)
		.setParameters("Y",MP_ID).list();
		for (X_MP_Maintain mnt:list) {
			createOTTaskDetail(mnt.getMP_Maintain_ID(),newOT,trxName);
			lookChilds(mnt.getMP_Maintain_ID(),newOT,trxName);
		}

		return true;
	}
	
	public void lookChilds(int MP_ID, X_MP_OT OT,String trxName){
		List <MMPMaintain> list = new Query(Env.getCtx(),MMPMaintain.Table_Name,MMPMaintain.COLUMNNAME_MP_MaintainParent_ID, trxName)
		.setParameters(MP_ID).list();
		
		for (X_MP_Maintain main:list){
			createOTTaskDetail(main.getMP_Maintain_ID(),OT, trxName);
			lookChilds(main.getMP_Maintain_ID(),OT,trxName);
		}
	}
	
	public boolean createOTTaskDetail(int MP_ID, X_MP_OT OT, String trxName){
/*		List <MMPMaintainTask> list = new Query(Env.getCtx(),MMPMaintainTask.Table_Name,
				MMPMaintainTask.COLUMNNAME_MP_Maintain_ID+"=?",trxName)
		.setParameters(MP_ID).list();
		
		for (X_MP_Maintain_Task task:list){
			MMPOTTask ta = new MMPOTTask(Env.getCtx(), 0,trxName);
 			ta.setAD_Org_ID(task.getAD_Org_ID());
 			ta.setMP_Maintain_ID(task.getMP_Maintain_ID());
			ta.setMP_OT_ID(OT.getMP_OT_ID());
			ta.setDescription(task.getDescription());
			ta.setDuration(task.getDuration());
			ta.setC_UOM_ID(task.getC_UOM_ID());
			ta.setStatus(ta.STATUS_NotStarted);
			ta.saveEx();
			
			createOTResourceDetail(task.getMP_Maintain_Task_ID(),ta.getMP_OT_Task_ID(),trxName);
		}
 
		//update MP
		updateMP(MP_ID,OT.getDateTrx(),OT.getDescription());
		*/
		String sql = "select * from MP_MAINTAIN_TASK where MP_MAINTAIN_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,MP_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				X_MP_OT_Task ta = new X_MP_OT_Task(Env.getCtx(), 0,null);
				ta.setMP_Maintain_ID(MP_ID);
				ta.setAD_Org_ID(rs.getInt("AD_Org_ID"));
				ta.setMP_OT_ID(OT.getMP_OT_ID());
				ta.setDescription(rs.getString("Description"));
				ta.setDuration(rs.getBigDecimal("Duration"));
				ta.setC_UOM_ID(rs.getInt("C_UOM_ID"));
				ta.setStatus(ta.STATUS_NotStarted);
				ta.saveEx();
				
				createOTResourceDetail(rs.getInt("MP_MAINTAIN_TASK_ID"),ta.getMP_OT_Task_ID(), trxName);
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}
		
		//update MP
		updateMP(MP_ID,OT.getDateTrx(),OT.getDescription());
		return true;
		
	}
	
	public boolean createOTResourceDetail(int oldTask_ID, int newTask_ID,String trxName){
/*		List<MMPMaintainResource>list = new Query(Env.getCtx(),MMPMaintainResource.Table_Name,MMPMaintainResource.COLUMNNAME_MP_Maintain_Task_ID+"=?",trxName)
		.setParameters(oldTask_ID).list();
		for (X_MP_Maintain_Resource res:list){
			MMPOTResource re=new MMPOTResource(Env.getCtx(), 0,trxName);
			re.setAD_Org_ID(res.getAD_Org_ID());
			re.setMP_OT_Task_ID(newTask_ID);
			re.setCostAmt(res.getCostAmt());
			re.setS_Resource_ID(res.getS_Resource_ID());
			re.setM_BOM_ID(res.getM_BOM_ID());
			re.setResourceQty(res.getResourceQty());
			re.setResourceType(res.getResourceType());
			re.set_ValueOfColumn("M_Product_ID",res.getM_Product_ID());
			re.saveEx();
		}	*/
		
		String sql = "select * from MP_MAINTAIN_RESOURCE where MP_MAINTAIN_TASK_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,oldTask_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				X_MP_OT_Resource re=new X_MP_OT_Resource(Env.getCtx(), 0,null);
				re.setAD_Org_ID(rs.getInt("AD_Org_ID"));
				re.setMP_OT_Task_ID(newTask_ID);
				re.setCostAmt(rs.getBigDecimal("CostAmt"));
				re.setS_Resource_ID(rs.getInt("S_Resource_ID"));
				re.setM_BOM_ID(rs.getInt("M_BOM_ID"));
				re.setResourceQty(rs.getBigDecimal("RESOURCEQTY"));
				re.setResourceType(rs.getString("RESOURCETYPE"));
				re.set_ValueOfColumn("M_Product_ID", rs.getInt("M_Product_ID"));
				re.saveEx();
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}
		return true;
		
	}
	

	public void updateMP(int MP_ID,Timestamp Datetrx,String description ){
		MMPMaintain mp= new MMPMaintain(Env.getCtx(), MP_ID,m_trx);
		mp.setdatelastrunmp(Datetrx);
		mp.setDateLastRun(Datetrx);
		if(mp.getProgrammingType().equals("C"))
			mp.setDateNextRun(new Timestamp(Datetrx.getTime()+(mp.getInterval().longValue()*86400000) ));
		else{
			mp.setnextmp(mp.getInterval().add(mp.getlastmp()).setScale(2, BigDecimal.ROUND_HALF_EVEN));
			mp.setlastmp(new BigDecimal(Float.parseFloat(description.split(":")[description.split(":").length-1].replace(',', '.'))).setScale(2, BigDecimal.ROUND_HALF_EVEN));
		}
			//mp.setNEXTMP(mp.getNEXTMP().add(mp.getINTERVAL().add( new BigDecimal(mp.getLASTMP().longValue()%mp.getINTERVAL().longValue()))));
		mp.save(); //update MP
	}
}
