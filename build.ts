await Bun.build({
	entrypoints: ["index.ts"],
	outdir: "./dist",
	target: "bun",
	//external: ["sharp"],
});

export {};
