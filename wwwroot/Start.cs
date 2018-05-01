using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

using StackExchange.Profiling;
using StackExchange.Profiling.Mvc;

namespace Samples.Mvc5
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            RegisterRoutes(RouteTable.Routes);
            RegisterBundles(BundleTable.Bundles);

            // RegisterGlobalFilters(GlobalFilters.Filters);
			
			// StackExchange.Profiling.Mvc.MiniProfilerMvc5
            MiniProfilerMvc5.Application_Start();
        }
        
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }

        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/bootstrap-theme.css",
                      "~/Content/site.css"));
        }

        /// <summary>
        /// The application begin request event.
        /// </summary>
        protected void Application_BeginRequest()
        {
            MiniProfiler profiler = MiniProfilerMvc5.Application_BeginRequest(Request);

            if (profiler != null)
            using (profiler.Step("Application_BeginRequest"))
            {
                // you can start profiling your code immediately
            }
        }

        /// <summary>
        /// The application end request.
        /// </summary>
        protected void Application_EndRequest()
        {
            MiniProfilerMvc5.Application_EndRequest(); // .Current?.Stop();
        }

    }
}
