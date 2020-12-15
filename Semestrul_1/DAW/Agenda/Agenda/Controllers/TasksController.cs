using Agenda.DataAccessLayer;
using Agenda.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Controllers
{
    
    public class TasksController : Controller
    {
        private readonly IDailyTaskRepo _repository;

        // dep injection
        public TasksController(IDailyTaskRepo repository)
        {
            _repository = repository; 
        }
        public IActionResult Index()
        {
            var taskItems = _repository.GetAllTasks();
            return View(taskItems);
        }

       
        /*public ActionResult FindTaskById(int id)
        {
            var taskItem = _repository.GetTaskById(id);
            
                return View(taskItem);
         
        }*/

        public ActionResult NewTask()
        {
            DailyTask tsk = new DailyTask();
            return View(tsk);
        }


        public ActionResult CreateTask(DailyTask tsk)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    _repository.CreateDailyTask(tsk);
                    _repository.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View(tsk);
            } catch(Exception e)
            {
                return View(tsk);
            }
        }

        
        public ActionResult Edit(int? id)
        {
            if (id.HasValue)
            {
                // cautam task-ul corespunzator in baza de date
                DailyTask tsk = _repository.GetTaskById((int)id);
                if (tsk == null)
                {
                    return NoContent();
                }
                return View(tsk);
            }
            return NoContent();
        }


        [HttpPost("update")]
        public ActionResult Update(int id, DailyTask taskReq)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DailyTask tsk = _repository.GetTaskById(taskReq.DailyTaskId);
                    tsk.TitluTask = taskReq.TitluTask;
                    tsk.Prioritate = taskReq.Prioritate;
                    tsk.Deadline = taskReq.Deadline;
                    _repository.UpdateDailyTask(tsk);
                    _repository.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View(taskReq);
            } catch (Exception e)
            {
                return View(taskReq);
            }
           
        }

        [HttpPost]
        public ActionResult DeleteTask(int id)
        {
            var tsk = _repository.GetTaskById(id);
            if (tsk == null)
            {
                return NotFound();
            }
            _repository.DeleteDailyTask(tsk);
            _repository.SaveChanges();
            return RedirectToAction("Index");

        }


    }
}
