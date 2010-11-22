package fr.patatepartie.handy;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;

import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.lib.StoredConfig;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;
import org.eclipse.jgit.transport.RefSpec;
import org.eclipse.jgit.transport.RemoteConfig;
import org.eclipse.jgit.transport.URIish;

import com.google.common.io.Files;

public class Installer {

	public static void main(String[] args) throws IOException, URISyntaxException {
		String installationDirectoryPath = args[0];
		String centralGitRepositoryPath = args[1];
		File installationDirectory = new File(installationDirectoryPath);
		
		Files.createParentDirs(new File(installationDirectory, "anyChild"));
		Repository repository = new FileRepositoryBuilder()
								.setWorkTree(new File(installationDirectory, "repo"))
								.build();
		
		repository.create();
		StoredConfig repositoryConfig = repository.getConfig();
		
		repositoryConfig.setString("branch", "master", "remote", "origin");
		repositoryConfig.setString("branch", "master", "merge", "refs/heads/master");

		RemoteConfig remoteConfig = new RemoteConfig(repositoryConfig, "origin");
		remoteConfig.addURI(new URIish(centralGitRepositoryPath));
		remoteConfig.addFetchRefSpec(new RefSpec("+refs/heads/*:refs/remotes/origin/*"));
		
		remoteConfig.update(repositoryConfig);
		repositoryConfig.save();
	}
}
