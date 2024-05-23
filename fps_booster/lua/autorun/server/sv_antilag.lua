if SERVER then

	hook.Add( "PreGamemodeLoaded", "widgets_disabler_cpu", function()
		function widgets.PlayerTick()
			-- empty
		end
		hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
		hook.Remove("PostRender", "RenderFrameBlend")
		hook.Remove("PreRender", "PreRenderFrameBlend")
		hook.Remove("Think", "DOFThink")
		hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
		hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
		hook.Remove("PostDrawEffects", "RenderWidgets")
		hook.Remove("Think", "RenderHalos")
		hook.Remove( "PlayerTick", "TickWidgets" )
end )

end
