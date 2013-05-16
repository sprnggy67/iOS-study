var defaultTemplates = {

	"empty" : {
		targets: [
			{
				name:"default",
				layout: {
					uniqueID:"defaultRoot",
					componentType:"grid",
					width:600, 
					height:800,
					rows:4, 
					columns:3,
					rowGutter:10,
					columnGutter:10,
					children: [
					]
				},
			}
		]
	},

	"emptyResponsive" : {
		targets: [
			{
				name:"default",
				portraitLayout: {
					uniqueID:"portraitRoot",
					componentType:"grid",
					width:600, 
					height:800,
					rows:4, 
					columns:3,
					rowGutter:10,
					columnGutter:10,
					children: [
					]
				},
				landscapeLayout: {
					uniqueID:"landscapeRoot",
					componentType:"grid",
					width:800, 
					height:600,
					rows:3, 
					columns:4,
					rowGutter:10,
					columnGutter:10,
					children: [
					]
				},
			}
		]
	},

	"front3": {
		targets: [ {
			name:"default",
			portraitLayout: {
				componentType:"grid",
				orientation:"landscape",
				width:600, 
				height:800,
				rows:4, 
				columns:3,
				rowGutter:10,
				columnGutter:10,
				children: [
					{
						componentType:"image",
						dataPath:"children",
						dataIndex:1,
						position: { left:0, top:0, width:3, height:2 },
					},
					{
						componentType:"flow",
						children: [
							{
								componentType:"headline",
								dataPath:"children",
								dataIndex:0,
								style:"font-size:20px; margin-top:0px",
							},
							{
								componentType:"standfirst",
								style:"font-size:20px;",
								dataPath:"children",
								dataIndex:0,
								style:"font-size:18px",
							},
							{
								componentType:"body",
								dataPath:"children",
								dataIndex:0,
								style:"font-size:16px",
							}
						],
						position: { left:0, top:2, width:3, height:1 }
					},
					{
						componentType:"flow",
						children: [
							{
								componentType:"headline",
								dataPath:"children",
								dataIndex:1,
								style:"font-size:20px; margin-top:0px",
							},
							{
								componentType:"standfirst",
								dataPath:"children",
								dataIndex:1,
								style:"font-size:16px;",
							},
						],
						position: { left:0, top:3, width:1.5, height:1 }
					},
					{
						componentType:"flow",
						children: [
							{
								componentType:"headline",
								dataPath:"children",
								dataIndex:2,
								style:"font-size:20px; margin-top:0px",
							},
							{
								componentType:"standfirst",
								dataPath:"children",
								dataIndex:2,
								style:"font-size:16px;",
							},
						],
						position: { left:1.5, top:3, width:1.5, height:1 }
					},
				]
			},
			landscapeLayout: {
				componentType:"grid",
				orientation:"landscape",
				width:800, 
				height:600,
				rows:3, 
				columns:4,
				rowGutter:10,
				columnGutter:10,
				children: [
					{
						componentType:"flow",
						children: [
							{
								componentType:"headline",
								dataPath:"children",
								dataIndex:0
							},
							{
								componentType:"standfirst",
								style:"font-size:20px;",
								dataPath:"children",
								dataIndex:0
							},
							{
								componentType:"body",
								dataPath:"children",
								dataIndex:0
							}
						],
						position: { left:0, top:0, width:1, height:3 }
					},
					{
						componentType:"image",
						dataPath:"children",
						dataIndex:1,
						position: { left:1, top:0, width:2, height:2 },
					},
					{
						componentType:"flow",
						children: [
							{
								componentType:"headline",
								dataPath:"children",
								dataIndex:1
							},
							{
								componentType:"standfirst",
								style:"font-size:20px;",
								dataPath:"children",
								dataIndex:1
							},
						],
						position: { left:1, top:2, width:2, height:1 }
					},
					{
						componentType:"flow",
						children: [
							{
								componentType:"headline",
								dataPath:"children",
								dataIndex:2
							},
							{
								componentType:"standfirst",
								style:"font-size:20px;",
								dataPath:"children",
								dataIndex:2
							},
							{
								componentType:"body",
								dataPath:"children",
								dataIndex:2
							}
						],
						position: { left:3, top:0, width:1, height:3 }
					},
				]
			}
		}]
	}
};
	