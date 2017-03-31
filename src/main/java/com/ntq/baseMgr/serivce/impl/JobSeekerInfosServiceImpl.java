package com.ntq.baseMgr.serivce.impl;

import com.ntq.baseMgr.dao.JobSeekerInfosMapper;
import com.ntq.baseMgr.entity.JobSeekerInfos;
import com.ntq.baseMgr.entity.JobSeekerResumeDelivery;
import com.ntq.baseMgr.service.IUploadFileService;
import com.ntq.baseMgr.service.JobSeekerInfosService;
import com.ntq.baseMgr.service.JobSeekerResumeDeliveryService;
import com.ntq.baseMgr.vo.JobSeekerInfosVo;
import com.ntq.baseMgr.vo.UploadFileVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

/**
 * <p>@description: 求职者信息处理Service</p>
 *
 * @projectName: interpolation
 * @packageName: com.ntq.baseMgr.serivce.impl
 * @className:
 * @author: shuangyang
 * @date: 17-3-19 下午2:37
 */
@Service
public class JobSeekerInfosServiceImpl extends BaseServiceImpl<JobSeekerInfos, Long> implements JobSeekerInfosService {
    @Autowired
    private JobSeekerInfosMapper jobSeekerInfosMapper;
    @Autowired
    private IUploadFileService uploadFileService;//上传文件的service
    @Autowired
    private JobSeekerResumeDeliveryService jobSeekerResumeDeliveryService;//处理上传附件相关信息

    @Autowired
    public void setBaseMapper() throws Exception {
        super.setBaseMapper(jobSeekerInfosMapper);
    }



    public void insertJobSeekerInfo(JobSeekerInfosVo jobSeekerInfosVo, UploadFileVo vo, HttpServletRequest request) throws Exception {
        //录入求职者信息
        //1.拼接简历名称 "username_"+"职位编码.doc"
        vo.setName(jobSeekerInfosVo.getJobSeekerName() + "_" + jobSeekerInfosVo.getJobCode() + ".doc");
        //2.上传附件处理并返回存储路径
        String storePath = uploadFileService.uploadForm(vo);
        //3.插入用户信息并返回id
        insertAndReturnKey(jobSeekerInfosVo);
        Long insertKey = jobSeekerInfosVo.getId();
        //4.存储附件相关信息
        JobSeekerResumeDelivery delivery = new JobSeekerResumeDelivery();
        delivery.setIsValid(true);
        delivery.setResumePath(storePath);
        delivery.setJobSeekerInfosId(insertKey);
        delivery.setServerCreateDate(new Date());
        delivery.setServerUpdateDate(new Date());
        delivery.setJobCode(jobSeekerInfosVo.getJobCode());
        delivery.setDealStatus(1);//默认处理状态
        jobSeekerResumeDeliveryService.insert(delivery);
    }
    /**
     * 插入求职者个人信息并返回key
     *
     * @param record
     * @return
     */
    @Override
    public Long insertAndReturnKey(JobSeekerInfos record) {
        record.setServerCreateDate(new Date());
        record.setServerUpdateDate(new Date());
        record.setIsValid(true);//默认设置信息有效
        return jobSeekerInfosMapper.insertAndReturnKey(record);
    }


    /**
     * 分页查询求职者信息
     * @param page 页码
     * @param size  分页大小
     * @param whereCondition 查询条件
     * @return
     */
    @Override
    public List<JobSeekerInfos> queryJobSeekerInfosListByCondition(int page, int size, String whereCondition) {
        return jobSeekerInfosMapper.queryJobSeekerInfosListByCondition((page - 1) * size, page * size, whereCondition);
    }

    /**
     * 通过求职者信息id查看投递简历相信信息
     * @param id
     * @return
     */
    @Override
    public JobSeekerInfosVo getJobSeekerInfoVoById(Long id) {
        //1.查询求职者的个人相关信息
        JobSeekerInfosVo jobSeekerInfosVo= (JobSeekerInfosVo) jobSeekerInfosMapper.getJobSeekerInfoById(id);
        //2.查询对应的求职者的简历信息的处理状态
        JobSeekerResumeDelivery jobSeekerResumeDelivery=jobSeekerResumeDeliveryService.getJobSeekerResumeDeliveryByJobSeekerId(id);
        //获取是否有效
        jobSeekerInfosVo.setIsValid(jobSeekerResumeDelivery.getIsValid());
        //获取存储路径
        jobSeekerInfosVo.setResumePath(jobSeekerResumeDelivery.getResumePath());
        //获取处理状态
        jobSeekerInfosVo.setDealStatus(jobSeekerResumeDelivery.getDealStatus());
        return jobSeekerInfosVo;
    }
}
