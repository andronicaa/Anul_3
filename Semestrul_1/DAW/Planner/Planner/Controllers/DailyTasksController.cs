using Microsoft.AspNet.Identity;
using Planner.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Controllers
{
    [AllowAnonymous]
    public class DailyTasksController : Controller
    {
        // se permite accesul utilizatorilor neautentificati
        private ApplicationDbContext _ctx = new ApplicationDbContext();
        public ActionResult Index()
        {
            // verific daca este cineva autentificat in acest moment
            var userId = User.Identity.GetUserId();
            if (userId != null)
            {
                // trebuie sa caut in baza de date doar task-urile corespunzatoare user-ului curent
                IEnumerable<DailyTask> taskListAuth = _ctx.DailyTasks.Where(p => p.UserId == userId).ToList();
                return View(taskListAuth);
            }
            // afisam toate task-urile din baza de date
            IEnumerable<DailyTask> taskList = _ctx.DailyTasks.Where(p => p.UserId == null).ToList();
            return View(taskList);
        }

        public ActionResult DetaliiTask(int? id)
        {
            if (id.HasValue)
            {
                // il cautam in baza de date
                DailyTask task = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
                if (task != null)
                {
                    return View(task);
                }
                return HttpNotFound("Nu exista task-ul cu id-ul dat");
            }
            return HttpNotFound();
        }

        public ActionResult NewTask()
        {
            DailyTask tsk = new DailyTask();
            var userId = User.Identity.GetUserId();
            tsk.Deadline = DateTime.Now;
            if (userId != null)
            {
                tsk.UserId = userId;
            }
            
            return View(tsk);
        }

        [HttpPost]
        public ActionResult CreateTask(DailyTask tsk)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var userId = User.Identity.GetUserId();
                    if (userId != null)
                    {
                        tsk.UserId = userId;
                    }
                    _ctx.DailyTasks.Add(tsk);
                    _ctx.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View("NewTask", tsk);
            }
            catch (Exception e)
            {
                return View("NewTask", tsk);
            }
        }

        public ActionResult Edit(int? id)
        {
            if (id.HasValue)
            {
                // cautam task-ul corespunzator in baza de date
                DailyTask tsk = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
                if (tsk == null)
                {
                    return HttpNotFound("Nu exista task-ul cu id-ul dat");
                }
                return View(tsk);
            }
            return HttpNotFound();
        }

        [HttpPost]
        public ActionResult Update(int id, DailyTask taskReq)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DailyTask tsk = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
                    var userId = User.Identity.GetUserId();
                    if (userId != null)
                    {
                        // verific daca este cine autentificat
                        tsk.UserId = taskReq.UserId;
                    }
                    tsk.TitluTask = taskReq.TitluTask;
                    tsk.Prioritate = taskReq.Prioritate;
                    tsk.Deadline = taskReq.Deadline;
                    tsk.Detalii = taskReq.Detalii;

                    _ctx.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View("Edit", taskReq);
            }
            catch (Exception e)
            {
                return View("Edit", taskReq);
            }

        }
        

        [HttpPost]
        public ActionResult DeleteTask(int id)
        {
            DailyTask tsk = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
            if (tsk == null)
            {
                return HttpNotFound("Nu exista task-ul cu id-ul dat");
            }
            _ctx.DailyTasks.Remove(tsk);
            _ctx.SaveChanges();
            return RedirectToAction("Index", "DailyTasks");

        }
    }
}