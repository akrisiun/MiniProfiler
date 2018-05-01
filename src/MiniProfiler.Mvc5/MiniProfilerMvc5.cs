using System.Web;
using System.Web.Mvc;
using StackExchange.Profiling;
using StackExchange.Profiling.Mvc;

namespace StackExchange
{
    // MiniProfilerMvc5
    public static class MiniProfilerMvc5
    {
        public static void Application_EndRequest() => MiniProfiler.Current?.Stop();

        public static void Application_Start(string RouteBasePath = "~/profiler")
        {
            RegisterGlobalFilters(GlobalFilters.Filters);

            // InitProfilerSettings
            MiniProfiler.Configure(
                new MiniProfilerOptions
                { RouteBasePath = RouteBasePath }
                // -> ProfilingViewEngineExtensions.AddViewPofiling(
                .AddViewPofiling()    // Add MVC view profiling 
                // .AddEntityFramework() // Add EF Core
                );
        }

        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new ProfilingActionFilter());
        }

        public static MiniProfiler Application_BeginRequest(HttpRequest Request)
        {
            MiniProfiler profiler = null;
            // might want to decide here (or maybe inside the action) whether you want
            if (Request.IsLocal)
            {
                profiler = MiniProfiler.StartNew();
            }

            return profiler;
        }
    }
}
