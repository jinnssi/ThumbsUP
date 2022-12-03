package com.spring.hyerin.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class MessageDAO implements InterMessageDAO {
	
	@Resource
	private SqlSessionTemplate sqlsession;
	
	@Override
	public List<Map<String,String>> getmvoList(Map<String, String> paraMap) {
		List<Map<String,String>> mvoList = sqlsession.selectList("message.getmvoList", paraMap);
		return mvoList;
	}

	// 메시지리스트의 총페이지수 알아오기
	@Override
	public int getmgtotal(Map<String, String> paraMap) {
		int mgtotal = sqlsession.selectOne("message.getmgtotal", paraMap);
		return mgtotal;
	}
	
	//로그인 유저가 클릭한 메시지내용 1개 불러오기
	@Override
	public MessageVO getmvo(String mno) {
		MessageVO mvo = sqlsession.selectOne("message.getmvo",mno);
		return mvo;
	}
	
	// 메시지 수신자 정보 알아오기
	@Override
	public List<MessageSendVO> getmsvoList(String mno) {
		List<MessageSendVO> msvoList = sqlsession.selectList("message.getmsvoList",mno);
		return msvoList;
	}
	
	// 메시지의 파일 정보 알아오기
	@Override
	public List<MessageFileVO> getmfile(String mno) {
		List<MessageFileVO> mfList = sqlsession.selectList("message.getmfile", mno);
		return mfList;
	}
	
	
	// 부서 정보 구해오기
	@Override
	public List<DepartmentsVO> getdept() {
		List<DepartmentsVO> deptList = sqlsession.selectList("message.getdept");
		return deptList;
	}
	
	//부서, 팀 이름 알아오기
	@Override
	public List<Map<String, String>> getdt() {
		List<Map<String, String>> dtList = sqlsession.selectList("message.getdt");
		return dtList;
	}
	
	//구성원 목록을 읽어오기
	@Override
	public List<EmployeeVO> getEmpList(Map<String, String> paraMap) {
		List<EmployeeVO> empList = sqlsession.selectList("message.getEmpList",paraMap);
		return empList;
	}
	
	// mno 채번해오기
	@Override
	public String getmno() {
		String mno = sqlsession.selectOne("message.getmno");
		return mno;
	}
	
	
	// tbl_message에 메시지 insert하기 
	@Override
	public int addMessage(MessageVO mvo) {
		int n = sqlsession.insert("message.addMessage", mvo);
		return n;
	}
	
	
	// tbl_message_file에 insert
	@Override
	public int addMF(MessageFileVO mfvo) {
		int n = sqlsession.insert("message.addMF", mfvo);
		return n;
	}
	
	// tbl_message_send에 수신자 insert하기
	@Override
	public int addMS(MessageSendVO msvo) {
		int n = sqlsession.insert("message.addMS", msvo);
		return n;
	}
	
	// 관련메시지 3개  알아오기
	@Override
	public Map<String,String> getmgroupList(Map<String, String> paraMap) {
		Map<String, String> mgroupList = sqlsession.selectOne("message.getmgroupList",paraMap);
		return mgroupList;
	}
	
	
	//해당 메시지 읽음처리하기
	@Override
	public int changeMgStatus(MessageSendVO msvo) {
		int n = sqlsession.update("message.changeMgStatus", msvo);
		return n;
	}
	
	// 탭별 메시지 개수 알아오기
	@Override
	public int getMgCnt(Map<String, String> paraMap) {
		int mgCnt = sqlsession.selectOne("message.getMgCnt",paraMap);
		return mgCnt;
	}

	
	
	
}
